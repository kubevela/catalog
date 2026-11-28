package main

import (
	"bytes"
	"fmt"
	"image"
	"image/color"
	_ "image/gif" // decodes GIF logos
	"image/jpeg"
	"image/png"

	_ "golang.org/x/image/webp" // decodes WEBP logos
)

// logoSize is the longest side of a raster logo: the site draws logos at most 40px, so this is sharp at 3x.
const logoSize = 128

// maxLogoBytes is the largest logo the generator downloads.
const maxLogoBytes = 4 << 20

// maxLogoPixels bounds a raster logo's declared size, read before decoding it: a small file can declare
// dimensions that take gigabytes to decode.
const maxLogoPixels = 25_000_000

// shrinkLogo returns a raster logo no larger than logoSize on its longest side, cropped to its centre square first
// when square is set: a JPEG when it is opaque, else a PNG. A logo already small and uncropped comes back as given;
// one that doesn't decode, or declares more than maxLogoPixels, is an error.
func shrinkLogo(data []byte, kind string, square bool) ([]byte, string, error) {
	cfg, _, err := image.DecodeConfig(bytes.NewReader(data))
	if err != nil {
		return nil, "", err
	}
	if cfg.Width*cfg.Height > maxLogoPixels {
		return nil, "", fmt.Errorf("%dx%d is more than %d pixels", cfg.Width, cfg.Height, maxLogoPixels)
	}
	src, _, err := image.Decode(bytes.NewReader(data))
	if err != nil {
		return nil, "", err
	}
	b := src.Bounds()
	if square {
		side := min(b.Dx(), b.Dy())
		x, y := b.Min.X+(b.Dx()-side)/2, b.Min.Y+(b.Dy()-side)/2
		b = image.Rect(x, y, x+side, y+side)
	}
	if !square && max(b.Dx(), b.Dy()) <= logoSize {
		return data, kind, nil
	}
	scale := float64(logoSize) / float64(max(b.Dx(), b.Dy()))
	if scale > 1 {
		scale = 1
	}
	w, h := max(1, int(float64(b.Dx())*scale)), max(1, int(float64(b.Dy())*scale))
	dst := image.NewNRGBA(image.Rect(0, 0, w, h))
	// Each destination pixel is the average of the source pixels it covers, taken premultiplied so a transparent
	// pixel's colour doesn't bleed into its neighbours.
	for dy := 0; dy < h; dy++ {
		y0, y1 := b.Min.Y+dy*b.Dy()/h, b.Min.Y+max((dy+1)*b.Dy()/h, dy*b.Dy()/h+1)
		for dx := 0; dx < w; dx++ {
			x0, x1 := b.Min.X+dx*b.Dx()/w, b.Min.X+max((dx+1)*b.Dx()/w, dx*b.Dx()/w+1)
			var r, g, bl, a, n uint64
			for y := y0; y < y1; y++ {
				for x := x0; x < x1; x++ {
					c := color.RGBA64Model.Convert(src.At(x, y)).(color.RGBA64)
					r, g, bl, a, n = r+uint64(c.R), g+uint64(c.G), bl+uint64(c.B), a+uint64(c.A), n+1
				}
			}
			dst.Set(dx, dy, color.RGBA64{R: uint16(r / n), G: uint16(g / n), B: uint16(bl / n), A: uint16(a / n)})
		}
	}
	var out bytes.Buffer
	if dst.Opaque() {
		if err := jpeg.Encode(&out, dst, &jpeg.Options{Quality: 85}); err != nil {
			return nil, "", err
		}
		return out.Bytes(), "jpg", nil
	}
	if err := png.Encode(&out, dst); err != nil {
		return nil, "", err
	}
	return out.Bytes(), "png", nil
}
