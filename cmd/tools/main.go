// +build tools
package main

// https://github.com/golang/go/issues/25922#issuecomment-414677877
import (
	_ "github.com/mdempsky/gocode"
	_ "github.com/ramya-rao-a/go-outline"
	_ "github.com/rogpeppe/godef"
	_ "github.com/uudashr/gopkgs/v2/cmd/gopkgs"
	_ "golang.org/x/lint/golint"
	_ "golang.org/x/tools/cmd/goimports"
	_ "golang.org/x/tools/cmd/guru"
)
