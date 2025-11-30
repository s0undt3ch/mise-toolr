# mise-toolr

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[mise](https://mise.jdx.dev) plugin for [ToolR](https://github.com/s0undt3ch/ToolR).

## About ToolR

ToolR (pronounced /ˈtuːlər/ - tool-er) is a Python-based CLI tool similar to invoke that provides in-project
CLI tooling support. It automatically discovers and registers commands from your project's `tools/` directory,
making it easy to organize and maintain project-specific CLI tools.

## Installation

### Step 1: Add the Plugin

Since this plugin is not yet in the mise registry, you need to add it manually first:

```bash
# Add the plugin from this repository
mise plugin add toolr https://github.com/s0undt3ch/mise-toolr.git

# Or if you're developing locally
mise plugin link toolr /path/to/mise-toolr
```

### Step 2: Install ToolR

Once the plugin is added, install ToolR:

```bash
# Install latest version globally
mise use -g toolr@latest

# Or install a specific version
mise use -g toolr@0.11.0
```

Or add to your `.mise.toml`:

```toml
[tools]
toolr = "latest"
```

Then run:
```bash
mise install
```

## Usage

Once installed via mise, ToolR will be available in your PATH:

```bash
# Check version
toolr --version

# Get help
toolr --help

# Run ToolR commands (requires a project with tools/ directory)
toolr <command>
```

## Requirements

- **Python 3.11+**: Automatically installed via mise if not available
  - The plugin will install Python via mise if it's not found
  - Or you can pre-install: `mise use -g python@3.11`
- Each ToolR version gets its own isolated Python virtual environment

## Virtual Environment Management

Each ToolR installation includes helper scripts for managing its Python environment:

- **`toolr-pip`** - Install Python packages in ToolR's virtual environment
- **`toolr-python`** - Run Python using ToolR's virtual environment

### Installing Additional Python Packages

```bash
# Install packages for your ToolR tools
toolr-pip install requests rich click

# Or from a requirements file
toolr-pip install -r requirements.txt

# List installed packages
toolr-pip list
```

See [VIRTUALENV.md](VIRTUALENV.md) for complete virtual environment management documentation.

## Development

### Local Testing

1. Link the plugin for development:
```bash
mise plugin link --force toolr .
```

2. Install a version:
```bash
mise install toolr@0.11.0
```

3. Test the installation:
```bash
mise exec toolr@0.11.0 -- toolr --version
```

4. Run the automated test suite:
```bash
mise run test
```

### Code Quality

This plugin uses [hk](https://hk.jdx.dev) for linting and pre-commit hooks:

```bash
# Install pre-commit hooks
hk install

# Run all linters
mise run lint

# Run full CI suite
mise run ci
```

## How It Works

This plugin:

1. Fetches available ToolR versions from the [GitHub releases API](https://github.com/s0undt3ch/ToolR/releases)
2. Creates a Python virtual environment for the specified version
3. Installs ToolR from PyPI using pip
4. Creates a wrapper script in `bin/` that activates the virtual environment and runs ToolR
5. Adds the `bin/` directory to your PATH

Each version is completely isolated in its own virtual environment, preventing conflicts between different ToolR
versions.

### Python Auto-Installation

If Python 3.11+ is not available when installing ToolR, the plugin will automatically:
1. Install Python 3.11 via mise (`mise use -g python@3.11`)
2. Use that Python to create ToolR's virtual environment
3. Install ToolR from PyPI into the virtual environment

This ensures ToolR always has a compatible Python version available.

## Publishing to mise Registry

Once the plugin is stable and tested, you can publish it to the official mise registry:

1. Ensure all tests pass:
   ```bash
   mise run ci
   ```

2. Create a pull request to add the plugin to the [mise registry](https://github.com/jdx/mise/blob/main/registry.toml):
   ```toml
   [plugins.toolr]
   description = "In-project CLI tooling support"
   repository = "https://github.com/s0undt3ch/mise-toolr"
   ```

3. After the PR is merged, users can install without manually adding the plugin:
   ```bash
   # No plugin add step needed!
   mise use -g toolr@latest
   ```

For more information, see the [mise Plugin Publishing Guide](https://mise.jdx.dev/plugin-publishing.html).

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.

## Documentation

### Plugin Documentation
- **[FAQ](FAQ.md)** - Frequently asked questions and answers
- **[Installation Guide](INSTALL.md)** - Comprehensive installation instructions
- **[Quick Start](QUICKSTART.md)** - Get started quickly
- **[Virtual Environment Management](VIRTUALENV.md)** - Managing Python packages and dependencies
- **[Contributing](CONTRIBUTING.md)** - How to contribute to the plugin

### ToolR Resources
- [ToolR Repository](https://github.com/s0undt3ch/ToolR)
- [ToolR Documentation](https://toolr.readthedocs.io/)

### mise Resources
- [mise Documentation](https://mise.jdx.dev)
- [mise Plugin Development Guide](https://mise.jdx.dev/tool-plugin-development.html)