package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

// This program is used to split multi-resources yaml file
// Command:
//   go run split-yaml.go kubeflow.yaml

func main() {
	if len(os.Args) < 2 {
		panic("please input filename")
	}
	filename := os.Args[1]
	fmt.Println("file:", filename)

	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	buf := bytes.NewBuffer(nil)
	var newFilename string
	var index int
	for scanner.Scan() {
		line := scanner.Text()
		switch {
		case strings.TrimSpace(line) == "---":
			if newFilename == "" {
				continue
			}
			writeFile(newFilename, index, buf.Bytes())
			index++
			buf = bytes.NewBuffer(nil)
			newFilename = ""
		case strings.HasPrefix(line, "kind:"):
			newFilename = line[6:]
			fallthrough
		default:
			buf.WriteString(line + "\n")
		}
	}
	if newFilename != "" {
		writeFile(newFilename, index, buf.Bytes())
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}
}

func writeFile(filename string, index int, b []byte) {
	filename = fmt.Sprintf("%s-%d.yaml", filename, index)
	err := ioutil.WriteFile(filename, b, 0600)
	if err != nil {
		panic(err)
	}
}
