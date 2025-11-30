# Installation Instructions

## Prerequisites

- [mise](https://mise.jdx.dev) installed
- **Python 3.11+** (optional - will be auto-installed via mise if not available)

## Quick Install

```bash
# 1. Add the plugin
mise plugin add toolr https://github.com/s0undt3ch/mise-toolr.git

# 2. Install ToolR
mise use -g toolr@latest

# 3. Verify installation
toolr --version
```

## Detailed Instructions

### 1. Install mise (if not already installed)

```bash
# macOS/Linux
curl https://mise.run | sh

# Or using Homebrew
brew install mise

# Windows (PowerShell)
irm https://mise.run | iex
```

For more installation options, see the [mise installation guide](https://mise.jdx.dev/getting-started.html).

### 2. Add the ToolR Plugin

Since this plugin is not yet in the official mise registry, you need to add it manually:

```bash
mise plugin add toolr https://github.com/s0undt3ch/mise-toolr.git
```

This command:
- Downloads the plugin from GitHub
- Registers it with mise
- Makes the `toolr` tool available for installation

**Note**: The plugin will automatically install Python 3.11 via mise if it's not already available.

### 3. Install ToolR

#### Global Installation

Install ToolR globally so it's available everywhere:

```bash
mise use -g toolr@latest
```

Or install a specific version:

```bash
mise use -g toolr@0.11.0
```

#### Project-Specific Installation

For project-specific installations, create or edit `.mise.toml` in your project root:

```toml
[tools]
toolr = "0.11.0"  # or "latest"
```

Then install:

```bash
cd your-project
mise install
```

Or use `.tool-versions` format:

```bash
echo "toolr 0.11.0" >> .tool-versions
mise install
```

### 4. Verify Installation

```bash
# Check ToolR version
toolr --version

# Get help
toolr --help

# Verify mise recognizes ToolR
mise which toolr

# Check available helper scripts
which toolr-pip toolr-python
```

## Managing Python Packages

Each ToolR installation includes helper scripts for managing its virtual environment:

### Install Additional Python Packages

```bash
# Install packages for your ToolR tools
toolr-pip install requests rich click

# Install from requirements file
toolr-pip install -r requirements.txt

# List installed packages
toolr-pip list

# Upgrade a package
toolr-pip install --upgrade requests
```

### Run Python in ToolR's Environment

```bash
# Run Python REPL
toolr-python

# Run a Python script
toolr-python script.py

# Run a module
toolr-python -m pip list
```

See [VIRTUALENV.md](VIRTUALENV.md) for complete documentation on managing ToolR's Python environment.

## Local Development Installation

If you're developing or testing the plugin locally:

```bash
# Clone the repository
git clone https://github.com/s0undt3ch/mise-toolr.git
cd mise-toolr

# Link the plugin
mise plugin link toolr .

# Install a version
mise install toolr@0.11.0

# Test it
mise exec toolr@0.11.0 -- toolr --version
```

## Updating

### Update the Plugin

```bash
mise plugin update toolr
```

### Upgrade ToolR

```bash
# Upgrade to latest version
mise use -g toolr@latest

# Or install a newer specific version
mise use -g toolr@0.11.0
```

## Uninstalling

### Uninstall a Specific Version

```bash
mise uninstall toolr@0.11.0
```

### Remove All Versions

```bash
mise uninstall toolr
```

### Remove the Plugin

```bash
mise plugin remove toolr
```

## Troubleshooting

### Python Not Found

The plugin automatically installs Python via mise if it's not available. If you still encounter issues:

```bash
# Manually install Python via mise
mise use -g python@3.11

# Verify Python is available
mise which python3

# If Python is available but ToolR installation fails:
# Check Python version
python3 --version

# Ensure it's 3.11 or later
# You can also install Python manually:
# On macOS:
brew install python@3.11

# On Ubuntu/Debian:
sudo apt update
sudo apt install python3.11 python3.11-venv

# On Windows:
# Download from https://www.python.org/downloads/
```

### Plugin Not Found

If mise can't find the plugin:

```bash
# List installed plugins
mise plugin ls

# If toolr is not listed, add it:
mise plugin add toolr https://github.com/s0undt3ch/mise-toolr.git
```

### Installation Fails

If installation fails:

```bash
# Enable debug mode
MISE_DEBUG=1 mise install toolr@0.11.0

# Check logs
mise doctor

# Try clearing cache
mise cache clear
mise install toolr@0.11.0
```

### Version Conflicts

Each ToolR version is isolated in its own virtual environment, so you can have multiple versions installed:

```bash
# List installed versions
mise ls toolr

# Use a specific version in a shell
mise shell toolr@0.11.0

# Or use temporarily
mise x toolr@0.10.1 -- toolr --help
```

## Platform-Specific Notes

### macOS

- Both Intel (x86_64) and Apple Silicon (arm64) are supported
- Python 3.11+ automatically installed via mise if needed
- Or manually install: `brew install python@3.11`

### Linux

- Supports x86_64 and aarch64 architectures
- Both glibc and musl-based distributions are supported
- Python 3.11+ automatically installed via mise if needed
- On some distros you may need: `sudo apt install python3-venv` (for Debian/Ubuntu)

### Windows

- Python 3.11+ automatically installed via mise if needed
- Or manually install from python.org or Microsoft Store
- The plugin creates `.bat` wrapper scripts for Windows
- Helper scripts: `toolr.bat`, `toolr-pip.bat`, `toolr-python.bat`

## Getting Help

- [ToolR Documentation](https://toolr.readthedocs.io/)
- [ToolR GitHub Issues](https://github.com/s0undt3ch/ToolR/issues)
- [mise Documentation](https://mise.jdx.dev)
- [Plugin GitHub Issues](https://github.com/s0undt3ch/mise-toolr/issues)

## What's Next?

After installation, check out:
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [VIRTUALENV.md](VIRTUALENV.md) - Managing Python packages in ToolR's environment
- [README.md](README.md) - Full documentation
- [ToolR Documentation](https://toolr.readthedocs.io/) - Learn how to use ToolR