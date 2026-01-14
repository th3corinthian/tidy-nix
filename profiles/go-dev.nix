{ pkgs, commonEnv, lib }:

{
  packages = with pkgs; [
    # Go toolchain
    go

    # Go development tools
    gopls          # Language server
    delve          # Debugger
    go-tools       # staticcheck, etc.
    gotools        # goimports, godoc, etc.

    # Additional tooling
    gore           # REPL for Go
    gomodifytags   # Modify struct tags
    impl           # Generate interface implementations

    # Testing and benchmarking
    gotestsum      # Pretty test output

    # Linting
    golangci-lint

    # Code generation
    protobuf
    protoc-gen-go

    # Build tools
    goreleaser     # Release automation
  ];

  shellHook = ''
    echo "[+]-> Go Development Environment"
    echo "[+]-> Go version: ${pkgs.go.version}"
    echo ""

    # Set up Go workspace
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$GOBIN:$PATH"

    # Go build cache
    export GOCACHE="$HOME/.cache/go-build"

    # Module behavior
    export GO111MODULE=on

    # Enable private modules if needed
    # export GOPRIVATE="github.com/yourorg/*"

    # Helpful aliases
    alias got='go test -v ./...'
    alias gob='go build -v ./...'
    alias gor='go run .'
    alias gofmt-all='gofmt -w .'
    alias golint-all='golangci-lint run ./...'

    # Delve debugger alias
    alias dlv-debug='dlv debug'
    alias dlv-test='dlv test'

    echo "[+] Quick commands:"
    echo "  got          # Run all tests"
    echo "  gob          # Build all packages"
    echo "  gor          # Run main package"
    echo "  golint-all   # Lint entire project"
    echo "  dlv debug    # Start debugger"
  '';

  env = {
    CGO_ENABLED = "1";  # Enable CGO by default
  };
}
