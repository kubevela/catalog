package main

import (
	"bytes"
	"image"
	"image/color"
	_ "image/gif" // decodes GIF logos
	"image/jpeg"
	"image/png"
)

// logoSize is the longest side of a raster logo: the site draws logos at most 40px, so this is sharp at 3x.
const logoSize = 128

// maxLogoBytes is the largest logo the generator downloads.
const maxLogoBytes = 4 << 20

// shrinkLogo returns a raster logo no larger than logoSize on its longest side, cropped to its centre square first
// when square is set: a JPEG when it is opaque, else a PNG. Bytes that don't decode, or are already small and uncropped, come back as given.
func shrinkLogo(data []byte, kind string, square bool) ([]byte, string) {
	src, _, err := image.Decode(bytes.NewReader(data))
	if err != nil {
		return data, kind
	}
	b := src.Bounds()
	if square {
		side := min(b.Dx(), b.Dy())
		x, y := b.Min.X+(b.Dx()-side)/2, b.Min.Y+(b.Dy()-side)/2
		b = image.Rect(x, y, x+side, y+side)
	}
	if !square && max(b.Dx(), b.Dy()) <= logoSize {
		return data, kind
	}
	scale := float64(logoSize) / float64(max(b.Dx(), b.Dy()))
	if scale > 1 {
		scale = 1
	}
	w, h := max(1, int(float64(b.Dx())*scale)), max(1, int(float64(b.Dy())*scale))
	dst := image.NewNRGBA(image.Rect(0, 0, w, h))
	// Each destination pixel is the average of the source pixels it covers.
	for dy := 0; dy < h; dy++ {
		y0, y1 := b.Min.Y+dy*b.Dy()/h, b.Min.Y+max((dy+1)*b.Dy()/h, dy*b.Dy()/h+1)
		for dx := 0; dx < w; dx++ {
			x0, x1 := b.Min.X+dx*b.Dx()/w, b.Min.X+max((dx+1)*b.Dx()/w, dx*b.Dx()/w+1)
			var r, g, bl, a, n uint64
			for y := y0; y < y1; y++ {
				for x := x0; x < x1; x++ {
					c := color.NRGBA64Model.Convert(src.At(x, y)).(color.NRGBA64)
					r, g, bl, a, n = r+uint64(c.R), g+uint64(c.G), bl+uint64(c.B), a+uint64(c.A), n+1
				}
			}
			dst.Set(dx, dy, color.NRGBA64{R: uint16(r / n), G: uint16(g / n), B: uint16(bl / n), A: uint16(a / n)})
		}
	}
	var out bytes.Buffer
	if dst.Opaque() {
		if err := jpeg.Encode(&out, dst, &jpeg.Options{Quality: 85}); err != nil {
			return data, kind
		}
		return out.Bytes(), "jpg"
	}
	if err := png.Encode(&out, dst); err != nil {
		return data, kind
	}
	return out.Bytes(), "png"
}
