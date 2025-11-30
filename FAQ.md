# Frequently Asked Questions (FAQ)

## General Questions

### What is mise-toolr?

mise-toolr is a [mise](https://mise.jdx.dev) plugin that allows you to install and manage 
[ToolR](https://github.com/s0undt3ch/ToolR) - a Python-based CLI tool for in-project tooling support.

### What is ToolR?

ToolR (pronounced /ˈtuːlər/ - tool-er) is a Python tool similar to invoke that automatically discovers and 
registers commands from your project's `tools/` directory, making it easy to organize project-specific CLI tools.

### Why use mise to install ToolR instead of pip?

Using mise provides several benefits:
- **Version management**: Install and switch between multiple ToolR versions
- **Isolation**: Each version has its own virtual environment
- **Project-specific versions**: Different projects can use different ToolR versions
- **No global pollution**: Doesn't affect your system Python
- **Automatic Python installation**: mise handles Python installation if needed

## Installation

### How do I install the plugin?

Since the plugin is not yet in the mise registry, you need to add it manually:

```bash
mise plugin add toolr https://github.com/s0undt3ch/mise-toolr.git
mise use -g toolr@latest
```

### Do I need to have Python installed first?

No! The plugin automatically installs Python 3.11 via mise if it's not available. Just run:

```bash
mise use -g toolr@latest
```

If Python is not found, the plugin will install it for you.

### Can I use my existing Python installation?

Yes. The plugin will use any available Python 3.11+ installation, whether it's:
- System Python
- Python installed via mise
- Python from Homebrew, pyenv, etc.

The plugin creates a virtual environment, so your existing Python installation won't be affected.

### What if I already have ToolR installed via pip?

The mise-installed ToolR is completely isolated in its own virtual environment. Your pip-installed ToolR and
mise-installed ToolR won't conflict with each other.

### How do I upgrade to a newer ToolR version?

```bash
# Upgrade to latest
mise use -g toolr@latest

# Or install a specific newer version
mise use -g toolr@0.11.0
```

### Can I have multiple ToolR versions installed?

Yes! Each version is isolated in its own virtual environment:

```bash
mise install toolr@0.11.0
mise install toolr@0.10.1

# Use different versions in different projects
cd project-a && echo "toolr 0.11.0" > .tool-versions
cd project-b && echo "toolr 0.10.1" > .tool-versions
```

## Python Package Management

### How do I install additional Python packages for ToolR?

Use the `toolr-pip` helper script:

```bash
toolr-pip install requests rich click
```

This installs packages into ToolR's isolated virtual environment.

### Where are packages installed?

Packages are installed in ToolR's virtual environment at:
```
~/.local/share/mise/installs/toolr/{version}/venv/
```

Each ToolR version has its own virtual environment.

### Can I use requirements.txt?

Yes! Each ToolR installation includes a `requirements.txt` template:

```bash
# Edit the requirements file
TOOLR_PATH=$(mise where toolr@0.11.0)
echo "requests>=2.31.0" >> "$TOOLR_PATH/requirements.txt"

# Install from it
toolr-pip install -r "$TOOLR_PATH/requirements.txt"
```

Or create your own:

```bash
# Project requirements
cat > my-requirements.txt << EOF
requests>=2.31.0
rich>=13.0.0
EOF

toolr-pip install -r my-requirements.txt
```

### Do packages persist across ToolR updates?

No. Each ToolR version has its own virtual environment. If you upgrade from 0.10.1 to 0.11.0, you'll need to
reinstall packages.

To make this easier:

```bash
# Export packages from old version
mise x toolr@0.10.1 -- toolr-pip freeze > requirements.txt

# Install new version
mise use -g toolr@0.11.0

# Reinstall packages
toolr-pip install -r requirements.txt
```

### Can I install packages from a private PyPI server?

Yes, use environment variables:

```bash
PIP_INDEX_URL=https://pypi.example.com/simple toolr-pip install private-package
```

### How do I uninstall a package?

```bash
toolr-pip uninstall package-name
```

## Usage

### How do I run ToolR?

After installation, just use the `toolr` command:

```bash
toolr --version
toolr --help
toolr your-command
```

### How do I run Python scripts in ToolR's environment?

Use the `toolr-python` helper:

```bash
# Run Python REPL
toolr-python

# Run a script
toolr-python script.py

# Run a module
toolr-python -m pip list
```

### Can I use ToolR with different Python versions?

Currently, the plugin installs Python 3.11. If you need a different version, you can manually install Python via
mise first:

```bash
# Install Python 3.12 via mise
mise use -g python@3.12

# Then install ToolR
mise use -g toolr@latest
```

The plugin will use the mise-managed Python 3.12.

### How do I use ToolR in a project?

1. Create a `.tool-versions` or `.mise.toml`:
   ```bash
   echo "toolr 0.11.0" > .tool-versions
   ```

2. Install:
   ```bash
   mise install
   ```

3. Create tools directory:
   ```bash
   mkdir tools
   touch tools/__init__.py
   ```

4. Write commands in `tools/*.py` and run with `toolr`

See [ToolR documentation](https://toolr.readthedocs.io/) for creating commands.

## Troubleshooting

### Installation fails with "Python not found"

The plugin should auto-install Python. If it fails:

```bash
# Manually install Python
mise use -g python@3.11

# Clear cache and retry
mise cache clear
mise install toolr@latest
```

### "toolr: command not found" after installation

Check that mise is properly configured:

```bash
# Verify mise is working
mise doctor

# Verify ToolR is installed
mise ls toolr

# Check PATH
mise which toolr

# If ToolR is installed but not in PATH, run:
eval "$(mise activate bash)"  # or zsh, fish, etc.
```

Add to your shell rc file:
```bash
# ~/.bashrc or ~/.zshrc
eval "$(mise activate bash)"  # or zsh
```

### Package installation fails

```bash
# Upgrade pip first
toolr-pip install --upgrade pip setuptools wheel

# Try again
toolr-pip install your-package
```

If installing packages with C extensions fails:

```bash
# Ubuntu/Debian
sudo apt-get install python3-dev build-essential

# macOS
xcode-select --install

# Then retry
toolr-pip install your-package
```

### ToolR can't find an installed package

Verify the package is in the correct environment:

```bash
# List packages
toolr-pip list

# Check Python path
toolr-python -c "import sys; print('\n'.join(sys.path))"

# Reinstall if needed
toolr-pip uninstall package-name
toolr-pip install package-name
```

### Different ToolR versions have different behavior

This is expected - each version is isolated. To check which version is active:

```bash
# Check current version
toolr --version

# Check which version mise is using
mise current toolr

# Use a specific version
mise shell toolr@0.11.0
```

### Virtual environment seems corrupted

Reinstall the ToolR version:

```bash
mise uninstall toolr@0.11.0
mise install toolr@0.11.0
```

This recreates the virtual environment from scratch.

### How do I clean up old versions?

```bash
# List installed versions
mise ls toolr

# Uninstall old versions
mise uninstall toolr@0.10.1

# Or uninstall all versions
mise uninstall toolr
```

## Performance

### Installation is slow

First-time installation downloads and builds Python (if needed) and creates a virtual environment. This is normal
and only happens once per version.

Subsequent installations of the same version are faster as mise caches downloads.

### Can I speed up installation?

```bash
# Use a specific Python version already installed
mise use -g python@3.11
mise use -g toolr@latest

# Clear old cache if it's stale
mise cache clear
```

## Advanced

### Can I modify the virtual environment directly?

Yes, but it's not recommended. Use `toolr-pip` instead. If you must:

```bash
# Activate the virtual environment
source ~/.local/share/mise/installs/toolr/0.11.0/venv/bin/activate

# Install packages
pip install package-name

# Deactivate
deactivate
```

### Can I use conda/mamba instead of venv?

No, the plugin uses Python's built-in `venv` module. If you need conda, consider installing ToolR directly with
conda instead of using this plugin.

### How do I use ToolR with Docker?

In your Dockerfile:

```dockerfile
FROM ubuntu:22.04

# Install mise
RUN curl https://mise.run | sh
ENV PATH="/root/.local/bin:${PATH}"

# Add ToolR plugin and install
RUN mise plugin add toolr https://github.com/s0undt3ch/mise-toolr.git
RUN mise use -g toolr@latest

# Your application
COPY . /app
WORKDIR /app
```

### Can I publish the ToolR virtual environment?

No, virtual environments are not portable. Instead, export and share the requirements:

```bash
# Export
toolr-pip freeze > requirements.txt

# Share requirements.txt with your team
# They install with:
toolr-pip install -r requirements.txt
```

### How does this compare to pipx?

Both isolate tools in virtual environments, but:

**mise-toolr**:
- Manages multiple versions simultaneously
- Project-specific versions via `.tool-versions`
- Integrates with mise ecosystem
- Automatic Python installation

**pipx**:
- Simpler for single-version installs
- Better for system-wide tools
- Doesn't manage multiple versions

Choose based on your needs.

## Contributing

### How can I contribute to the plugin?

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### I found a bug, where do I report it?

Open an issue on [GitHub](https://github.com/s0undt3ch/mise-toolr/issues).

### Can I test unreleased ToolR versions?

Yes:

```bash
# Install from a specific git commit/tag
# (Not directly supported, but you can manually edit the plugin)

# Or test with pip in the virtual environment
toolr-pip install git+https://github.com/s0undt3ch/ToolR.git@main
```

## Documentation

### Where can I find more information?

- **ToolR**: [Official Documentation](https://toolr.readthedocs.io/)
- **mise**: [mise Documentation](https://mise.jdx.dev)
- **Plugin**: 
  - [README.md](README.md) - Main documentation
  - [INSTALL.md](INSTALL.md) - Installation guide
  - [QUICKSTART.md](QUICKSTART.md) - Quick start
  - [VIRTUALENV.md](VIRTUALENV.md) - Virtual environment management
  - [CONTRIBUTING.md](CONTRIBUTING.md) - Contributing guidelines

### Is there a Discord/Slack for help?

Check the [ToolR repository](https://github.com/s0undt3ch/ToolR) and
[mise documentation](https://mise.jdx.dev) for community links.

### How do I stay updated?

- Watch the [mise-toolr repository](https://github.com/s0undt3ch/mise-toolr)
- Watch the [ToolR repository](https://github.com/s0undt3ch/ToolR)
- Follow mise updates at [mise.jdx.dev](https://mise.jdx.dev)

## Still Have Questions?

- Check the [ToolR documentation](https://toolr.readthedocs.io/)
- Read the [mise documentation](https://mise.jdx.dev)
- Open an issue on [GitHub](https://github.com/s0undt3ch/mise-toolr/issues)