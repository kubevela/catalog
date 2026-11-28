package main

import (
	"bytes"
	"image"
	"image/color"
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
	size := func(data []byte) image.Image {
		img, err := png.Decode(bytes.NewReader(data))
		if err != nil {
			t.Fatal(err)
		}
		return img
	}

	small := encodePNG(t, 64, 64, red)
	if out, kind := shrinkLogo(small, "png", false); !bytes.Equal(out, small) || kind != "png" {
		t.Errorf("a small logo should come back unchanged")
	}

	out, _ := shrinkLogo(encodePNG(t, 1000, 500, red), "png", false)
	if b := size(out).Bounds(); b.Dx() != 256 || b.Dy() != 128 {
		t.Errorf("1000x500 shrank to %dx%d, want 256x128", b.Dx(), b.Dy())
	}

	out, _ = shrinkLogo(encodePNG(t, 1000, 400, banner), "png", true)
	img := size(out)
	if b := img.Bounds(); b.Dx() != 256 || b.Dy() != 256 {
		t.Errorf("square crop of 1000x400 is %dx%d, want 256x256", b.Dx(), b.Dy())
	}
	if r, _, bl, _ := img.At(0, 128).RGBA(); r == 0 || bl != 0 {
		t.Errorf("square crop should keep the banner's centre, got left edge r=%d b=%d", r, bl)
	}

	if out, kind := shrinkLogo([]byte("not an image"), "png", true); string(out) != "not an image" || kind != "png" {
		t.Errorf("undecodable bytes should come back unchanged")
	}
}
