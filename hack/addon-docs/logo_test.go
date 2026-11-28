package main

import (
	"bytes"
	"image"
	"image/color"
	_ "image/jpeg"
	"image/png"
	"testing"
)

func encodePNG(t *testing.T, w, h int, fill func(x, y int) color.Color) []byte {
	t.Helper()
	img := image.NewNRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			img.Set(x, y, fill(x, y))
		}
	}
	var b bytes.Buffer
	if err := png.Encode(&b, img); err != nil {
		t.Fatal(err)
	}
	return b.Bytes()
}

func TestShrinkLogo(t *testing.T) {
	red := func(int, int) color.Color { return color.NRGBA{R: 255, A: 255} }
	// A banner: blue edges, red centre square.
	banner := func(x, _ int) color.Color {
		if x < 300 || x >= 700 {
			return color.NRGBA{B: 255, A: 255}
		}
		return color.NRGBA{R: 255, A: 255}
	}
	size := func(data []byte, _ string) image.Image {
		img, _, err := image.Decode(bytes.NewReader(data))
		if err != nil {
			t.Fatal(err)
		}
		return img
	}

	small := encodePNG(t, 64, 64, red)
	if out, kind := shrinkLogo(small, "png", false); !bytes.Equal(out, small) || kind != "png" {
		t.Errorf("a small logo should come back unchanged")
	}

	clear := func(int, int) color.Color { return color.NRGBA{R: 255, A: 128} }
	out, kind := shrinkLogo(encodePNG(t, 1000, 500, clear), "png", false)
	if b := size(out, kind).Bounds(); b.Dx() != 128 || b.Dy() != 64 || kind != "png" {
		t.Errorf("translucent 1000x500 became a %dx%d %s, want a 128x64 png", b.Dx(), b.Dy(), kind)
	}

	out, kind = shrinkLogo(encodePNG(t, 1000, 400, banner), "png", true)
	img := size(out, kind)
	if b := img.Bounds(); b.Dx() != 128 || b.Dy() != 128 || kind != "jpg" {
		t.Errorf("square crop of an opaque 1000x400 is a %dx%d %s, want a 128x128 jpg", b.Dx(), b.Dy(), kind)
	}
	if r, _, bl, _ := img.At(2, 64).RGBA(); r < 0xc000 || bl > 0x4000 {
		t.Errorf("square crop should keep the banner's centre, got left edge r=%d b=%d", r, bl)
	}

	if out, kind := shrinkLogo([]byte("not an image"), "png", true); string(out) != "not an image" || kind != "png" {
		t.Errorf("undecodable bytes should come back unchanged")
	}
}
