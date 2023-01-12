package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

var SchemaTemple = `- jsonKey: writeConnectionSecretToRef
  disable: true
- jsonKey: providerRef
  disable: true
- jsonKey: region
  disable: true

`

func main() {
	schemas, err := listTerraformSchemaFiles()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	for _, schema := range schemas {
		if _, err := os.Stat(filepath.Dir(schema)); err != nil {
			if os.IsNotExist(err) {
				if err := os.MkdirAll(filepath.Dir(schema), 0755); err != nil {
					fmt.Printf("Failed to create directory %s: %v", filepath.Dir(schema), err)
					os.Exit(1)
				}
			}
		}
		if err := ioutil.WriteFile(schema, []byte(SchemaTemple), 0644); err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	}
	fmt.Println("Successfully generated terraform schema files")
}

func listTerraformSchemaFiles() ([]string, error) {
	const (
		prefix = "terraform-"
	)
	pwd, err := os.Getwd()
	if err != nil {
		return nil, err
	}

	addons := filepath.Join(pwd, "addons")
	infos, err := ioutil.ReadDir(addons)
	if err != nil {
		return nil, err
	}
	var files []string
	for _, info := range infos {
		if info.IsDir() && strings.HasPrefix(info.Name(), "terraform-") {
			providerPath := filepath.Join(addons, info.Name())
			definitionsPath := filepath.Join(providerPath, "definitions")
			definitions, err := ioutil.ReadDir(definitionsPath)
			if err != nil {
				return nil, err
			}
			for _, definition := range definitions {
				if strings.HasPrefix(definition.Name(), prefix) {
					name := strings.Split(definition.Name(), prefix)[1]
					files = append(files, filepath.Join(providerPath, "schemas", fmt.Sprintf("component-uischema-%s", name)))
				}
			}
			continue
		}
	}
	return files, nil
}
