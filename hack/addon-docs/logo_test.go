package main

import (
	"bytes"
	"encoding/binary"
	"hash/crc32"
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
	if out, kind, _ := shrinkLogo(small, "png", false); !bytes.Equal(out, small) || kind != "png" {
		t.Errorf("a small logo should come back unchanged")
	}

	clear := func(int, int) color.Color { return color.NRGBA{R: 255, A: 128} }
	out, kind, _ := shrinkLogo(encodePNG(t, 1000, 500, clear), "png", false)
	if b := size(out, kind).Bounds(); b.Dx() != 128 || b.Dy() != 64 || kind != "png" {
		t.Errorf("translucent 1000x500 became a %dx%d %s, want a 128x64 png", b.Dx(), b.Dy(), kind)
	}

	out, kind, _ = shrinkLogo(encodePNG(t, 1000, 400, banner), "png", true)
	img := size(out, kind)
	if b := img.Bounds(); b.Dx() != 128 || b.Dy() != 128 || kind != "jpg" {
		t.Errorf("square crop of an opaque 1000x400 is a %dx%d %s, want a 128x128 jpg", b.Dx(), b.Dy(), kind)
	}
	if r, _, bl, _ := img.At(2, 64).RGBA(); r < 0xc000 || bl > 0x4000 {
		t.Errorf("square crop should keep the banner's centre, got left edge r=%d b=%d", r, bl)
	}

	if _, _, err := shrinkLogo([]byte("not an image"), "png", true); err == nil {
		t.Errorf("undecodable bytes should be refused")
	}
}

func TestShrinkLogoKeepsTransparentEdgesClean(t *testing.T) {
	// Opaque red columns beside fully transparent black ones: averaged, the colour must stay red, at half alpha.
	stripes := func(x, _ int) color.Color {
		if x%2 == 0 {
			return color.NRGBA{R: 255, A: 255}
		}
		return color.NRGBA{}
	}
	out, kind, err := shrinkLogo(encodePNG(t, 512, 512, stripes), "png", false)
	if err != nil {
		t.Fatal(err)
	}
	img, _, err := image.Decode(bytes.NewReader(out))
	if err != nil || kind != "png" {
		t.Fatalf("got a %s: %v", kind, err)
	}
	c := color.NRGBAModel.Convert(img.At(10, 10)).(color.NRGBA)
	if c.R < 250 || c.A < 120 || c.A > 136 {
		t.Errorf("averaged pixel is %+v, want red at about half alpha", c)
	}
}

func TestShrinkLogoRefusesHugeDimensions(t *testing.T) {
	// A tiny PNG whose header claims 100000x100000 pixels.
	data := encodePNG(t, 1, 1, func(int, int) color.Color { return color.NRGBA{A: 255} })
	binary.BigEndian.PutUint32(data[16:], 100000)
	binary.BigEndian.PutUint32(data[20:], 100000)
	binary.BigEndian.PutUint32(data[29:], crc32.ChecksumIEEE(data[12:29]))
	if _, _, err := shrinkLogo(data, "png", false); err == nil {
		t.Error("a logo claiming 100000x100000 pixels should be refused before it is decoded")
	}
}

func TestShrinkLogoDecodesWebP(t *testing.T) {
	// The smallest lossless WEBP: 1x1, opaque.
	webp := []byte("RIFF\x1a\x00\x00\x00WEBPVP8L\x0d\x00\x00\x00\x2f\x00\x00\x00\x10\x07\x10\x11\x11\x88\x88\xfe\x07\x00")
	if _, _, err := image.DecodeConfig(bytes.NewReader(webp)); err != nil {
		t.Fatalf("WEBP isn't registered: %v", err)
	}
}

func TestOverridesRefuseUnknownCrop(t *testing.T) {
	o := Overrides{Addons: map[string]Override{"x": {LogoCrop: "sqaure"}}}
	if err := o.check(); err == nil {
		t.Error(`logoCrop "sqaure" should be refused`)
	}
}
