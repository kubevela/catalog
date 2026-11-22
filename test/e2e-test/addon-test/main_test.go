package main

import "testing"

func TestCheckUpgradeAddonVersion(t *testing.T) {
	cases := []struct {
		name    string
		changed []string
		wantErr bool
	}{
		{"addon file with its metadata", []string{"addons/foo/readme.md", "addons/foo/metadata.yaml"}, false},
		{"addon file without its metadata", []string{"addons/foo/readme.md"}, true},
		{"experimental addon file without its metadata", []string{"experimental/addons/foo/readme.md"}, true},
		{"readme beside the addons", []string{"addons/README.md"}, false},
		{"readme beside the experimental addons", []string{"experimental/addons/README.md"}, false},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			err := checkUpgradeAddonVersion(c.changed)
			if (err != nil) != c.wantErr {
				t.Fatalf("checkUpgradeAddonVersion(%v) error = %v, wantErr %v", c.changed, err, c.wantErr)
			}
		})
	}
}
