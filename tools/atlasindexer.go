package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

type Atlas struct {
	Image string `json:"image"`
	Data  string `json:"data"`
}

type AssetGroup struct {
	Atlases []Atlas `json:"atlases"`
}

var assets AssetGroup
var root string

func imageExtensionExists(path string, ext string) string {
	base := strings.Split(path, ".")[0]

	_, err := os.Stat(base + ext)
	fmt.Print(base)
	if err != nil {
		return base + ext
	}

	return ""
}

func imageExists(path string) (exists bool, img string) {
	exists = false
	img = imageExtensionExists(path, ".png")
	if img != "" {
		exists = true
		return exists, ".png"
	}

	img = imageExtensionExists(path, ".jpg")
	if img != "" {
		exists = true
		return exists, ".jpg"
	}

	img = imageExtensionExists(path, ".ttf")
	if img != "" {
		exists = true
		return exists, ".ttf"
	}

	return false, ""
}

func visit(path string, f os.FileInfo, err error) error {
	if strings.Contains(path, ".json") && !strings.Contains(path, "atlasindex") {
		newAtlas := Atlas{
			Image: "",
			Data:  strings.Split(path, root)[1],
		}

		exists, img := imageExists(path)
		if exists {
			base := strings.Split(path, root)[1]
			newAtlas.Image = strings.Split(base, ".")[0] + img
			assets.Atlases = append(assets.Atlases, newAtlas)
		}
	}

	return nil
}

func main() {
	flag.Parse()
	root = flag.Arg(0)
	assets = AssetGroup{
		Atlases: []Atlas{},
	}
	err := filepath.Walk(root, visit)
	data, err := json.Marshal(assets)
	if err != nil {
		fmt.Println("error: ", err)
	}
	ioutil.WriteFile(flag.Arg(0)+"atlasindex.json", data, 0777)
}
