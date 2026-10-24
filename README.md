# Mac bootstrap

macOS setup with mise.

## Install Command Line Tools

```sh
xcode-select --install
```

Wait for installation to finish before continuing.

## Install mise

```sh
curl -fsSL https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
```

## Bootstrap

```sh
mise bootstrap --from https://github.com/totr/mac-bootstrap.git
```

## AI server (optional)

For a Mac mini or Mac Studio used as a remotely accessed AI server, follow the
[manual setup](AI-SERVER.md).
