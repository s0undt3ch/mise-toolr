# Quick Start Guide

## Step 1: Add the Plugin

Since this plugin is not yet in the mise registry, add it manually first:

```bash
# Add the plugin from GitHub
mise plugin add toolr https://github.com/s0undt3ch/mise-toolr.git
```

## Step 2: Install ToolR

```bash
# Install ToolR globally
mise use -g toolr@latest

# Or install a specific version
mise use -g toolr@0.11.0
```

**Note**: Python 3.11+ will be automatically installed via mise if it's not already available.

## Verify Installation

```bash
toolr --version

# Check helper scripts are available
which toolr-pip toolr-python
```

## Use ToolR in Your Project

1. **Create a tools directory in your project:**
   ```bash
   mkdir tools
   touch tools/__init__.py
   ```

2. **Write your first command** in `tools/example.py`:
   ```python
   from toolr import Context, command_group

   group = command_group("example", "Example Commands", "Example command group")

   @group.command
   def hello(ctx: Context, name: str = "World"):
       """Say hello to someone.

       Args:
           name: The name to say hello to.
       """
       ctx.print(f"Hello, {name}!")
   ```

3. **Run your command:**
   ```bash
   toolr example hello --name Alice
   ```

## Installing Python Packages for ToolR

Each ToolR installation has its own virtual environment. Install packages using `toolr-pip`:

```bash
# Install packages for your ToolR tools
toolr-pip install requests rich click

# Install from a requirements file
toolr-pip install -r requirements.txt

# List installed packages
toolr-pip list

# Upgrade a package
toolr-pip install --upgrade requests
```

### Run Python Scripts in ToolR's Environment

```bash
# Run Python REPL
toolr-python

# Run a script with ToolR's dependencies
toolr-python my_script.py

# Run a module
toolr-python -m pip list
```

See [VIRTUALENV.md](VIRTUALENV.md) for complete documentation.

## Project-Specific ToolR Version

First, make sure the plugin is added (see Step 1 above), then add to your project's `.mise.toml`:

```toml
[tools]
toolr = "0.11.0"
```

Then run:
```bash
mise install
```

### Managing Project Dependencies

Create a `toolr-requirements.txt` in your project:

```txt
# ToolR project dependencies
requests>=2.31.0
rich>=13.0.0
pyyaml>=6.0
```

Install them:
```bash
toolr-pip install -r toolr-requirements.txt
```

## Multiple Versions

You can have different ToolR versions for different projects (after adding the plugin):

```bash
# Project A uses 0.11.0
cd project-a
echo "toolr 0.11.0" > .tool-versions
mise install

# Project B uses 0.10.1
cd project-b
echo "toolr 0.10.1" > .tool-versions
mise install
```

## Useful Commands

```bash
# List available versions
mise ls-remote toolr

# List installed versions
mise ls toolr

# Use a specific version temporarily
mise x toolr@0.11.0 -- toolr --help

# Uninstall a version
mise uninstall toolr@0.11.0

# Upgrade to latest
mise use -g toolr@latest
```

## Learn More

- [ToolR Documentation](https://toolr.readthedocs.io/)
- [ToolR GitHub](https://github.com/s0undt3ch/ToolR)
- [Virtual Environment Management](VIRTUALENV.md) - Complete guide for managing Python packages
- [mise Documentation](https://mise.jdx.dev)