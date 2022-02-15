package main

import (
	"bytes"
	"errors"
	"fmt"
	"html/template"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/Masterminds/sprig/v3"
	"github.com/go-yaml/yaml"
)

type Provider struct {
	Name       string     `yaml:"shortCloudName"`
	CloudName  string     `yaml:"completeCloudName"`
	Properties []Property `yaml:"cloudProperties"`
	Region     string     `yaml:"region"`
}

type Property struct {
	Name        string `yaml:"name"`
	SecretKey   string `yaml:"secretKey"`
	Description string `yaml:"description"`
	IsRegion    bool   `yaml:"isRegion"`
}

const (
	addonsPath                = "addons/"
	terraformProviderScaffold = "./hack/addons/terraform/terraform-provider-scaffold"
)

func genAddon(provider Provider) error {
	if provider.Name == "" {
		return errors.New("provider name is empty")
	}
	targetProviderAddonPath := filepath.Join(addonsPath, "terraform-"+provider.Name)
	if _, err := os.Stat(targetProviderAddonPath); !os.IsNotExist(err) {
		os.RemoveAll(targetProviderAddonPath)
	}
	fmt.Printf("Generating addon for provider %s in %s\n", provider.Name, targetProviderAddonPath)
	if err := os.MkdirAll(targetProviderAddonPath, 0755); err != nil {
		return err
	}

	fileInfos, err := ioutil.ReadDir(terraformProviderScaffold)
	if err != nil {
		panic(err)
	}
	for _, info := range fileInfos {
		if info.IsDir() {
			targetProviderAddonSubPath := filepath.Join(targetProviderAddonPath, info.Name())
			fmt.Printf("Create directory %s\n", targetProviderAddonSubPath)
			if err := os.Mkdir(targetProviderAddonSubPath, 0755); err != nil {
				return err
			}
			sourceProviderAddonSubPath := filepath.Join(terraformProviderScaffold, info.Name())
			tmp, err := ioutil.ReadDir(sourceProviderAddonSubPath)
			if err != nil {
				return err
			}
			for _, t := range tmp {
				sourceFile := filepath.Join(sourceProviderAddonSubPath, t.Name())
				data, err := ioutil.ReadFile(sourceFile)
				if err != nil {
					return err
				}
				fmt.Printf("Rendering %s\n", sourceFile)
				name := t.Name()
				if t.Name() != "parameter.cue" {
					name = provider.Name + "-" + t.Name()
				}
				if err := render(data, targetProviderAddonSubPath, name, provider); err != nil {
					return err
				}
			}
		} else {
			sourceFile := filepath.Join(terraformProviderScaffold, info.Name())
			data, err := ioutil.ReadFile(sourceFile)
			if err != nil {
				return err
			}
			fmt.Printf("Rendering %s\n", sourceFile)
			if err := render(data, targetProviderAddonPath, info.Name(), provider); err != nil {
				return err
			}
		}
	}
	return nil
}

func render(data []byte, path, name string, provider Provider) error {
	target := filepath.Join(path, name)
	t, err := template.New("").Funcs(sprig.FuncMap()).Parse(string(data))
	var rendered bytes.Buffer
	err = t.Execute(&rendered, provider)
	if err != nil {
		return err
	}
	return ioutil.WriteFile(target, rendered.Bytes(), 0644)
}

func main() {
	var provider Provider
	config, err := os.ReadFile("hack/addons/terraform/terraform-provider-scaffold/metadata.yaml")
	if err != nil {
		panic(err)
	}
	if err := yaml.Unmarshal(config, &provider); err != nil {
		panic(err)
	}

	if err := genAddon(provider); err != nil {
		panic(err)
	}
}
