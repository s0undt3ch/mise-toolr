# Virtual Environment Management

This guide explains how to manage the Python virtual environment that mise-toolr creates for each ToolR installation.

## Overview

Each ToolR version installed via mise gets its own isolated Python virtual environment. This ensures:

- **Complete isolation** between different ToolR versions
- **No conflicts** with system Python or other tools
- **Clean installation** of additional dependencies
- **Easy cleanup** when uninstalling

## Virtual Environment Location

When you install ToolR with mise, a virtual environment is created at:

```
~/.local/share/mise/installs/toolr/{version}/venv/
```

For example:
```
~/.local/share/mise/installs/toolr/0.11.0/venv/
```

## Installing Additional Python Packages

ToolR provides helper scripts to manage packages in its virtual environment.

### Method 1: Using toolr-pip (Recommended)

The `toolr-pip` wrapper script allows you to install packages directly into ToolR's virtual environment:

```bash
# Install a package
mise x toolr@0.11.0 -- toolr-pip install requests

# Install multiple packages
mise x toolr@0.11.0 -- toolr-pip install requests rich click

# Install a specific version
mise x toolr@0.11.0 -- toolr-pip install "requests>=2.31.0"

# Upgrade a package
mise x toolr@0.11.0 -- toolr-pip install --upgrade requests

# Uninstall a package
mise x toolr@0.11.0 -- toolr-pip uninstall requests
```

If you have ToolR set as your active version:

```bash
# Set as active version
mise use toolr@0.11.0

# Now you can use toolr-pip directly
toolr-pip install requests
toolr-pip list
toolr-pip freeze
```

### Method 2: Using requirements.txt

Each ToolR installation includes a `requirements.txt` file for managing dependencies:

**Location**: `~/.local/share/mise/installs/toolr/{version}/requirements.txt`

1. **Edit the requirements file**:
   ```bash
   # Find the installation path
   mise where toolr@0.11.0
   
   # Edit requirements.txt
   cat >> ~/.local/share/mise/installs/toolr/0.11.0/requirements.txt << EOF
   requests>=2.31.0
   rich>=13.0.0
   click>=8.1.0
   EOF
   ```

2. **Install from requirements.txt**:
   ```bash
   TOOLR_PATH=$(mise where toolr@0.11.0)
   toolr-pip install -r "$TOOLR_PATH/requirements.txt"
   ```

### Method 3: Direct Virtual Environment Access

You can also access the virtual environment directly:

```bash
# Activate the virtual environment
source ~/.local/share/mise/installs/toolr/0.11.0/venv/bin/activate

# Install packages
pip install requests rich

# Deactivate when done
deactivate
```

On Windows:
```powershell
# Activate
~\.local\share\mise\installs\toolr\0.11.0\venv\Scripts\activate

# Install packages
pip install requests rich

# Deactivate
deactivate
```

## Running Python in ToolR's Environment

### Using toolr-python

The `toolr-python` wrapper runs Python using ToolR's virtual environment:

```bash
# Run Python REPL
mise x toolr@0.11.0 -- toolr-python

# Run a Python script
mise x toolr@0.11.0 -- toolr-python script.py

# Run a Python module
mise x toolr@0.11.0 -- toolr-python -m pip list

# Check Python version
mise x toolr@0.11.0 -- toolr-python --version
```

If ToolR is active:
```bash
mise use toolr@0.11.0
toolr-python script.py
```

### Example: Running a Script with Dependencies

```bash
# Install dependencies
toolr-pip install requests beautifulsoup4

# Create a script
cat > scraper.py << 'EOF'
import requests
from bs4 import BeautifulSoup

response = requests.get('https://example.com')
soup = BeautifulSoup(response.content, 'html.parser')
print(soup.title.string)
EOF

# Run with ToolR's Python
toolr-python scraper.py
```

## Listing Installed Packages

```bash
# List all packages in ToolR's environment
toolr-pip list

# List in requirements format
toolr-pip freeze

# Show details about a specific package
toolr-pip show requests
```

## Creating a Reproducible Environment

To create a reproducible ToolR environment across machines:

1. **Export current packages**:
   ```bash
   toolr-pip freeze > my-toolr-requirements.txt
   ```

2. **On another machine**, install the same packages:
   ```bash
   # Install ToolR
   mise use toolr@0.11.0
   
   # Install packages
   toolr-pip install -r my-toolr-requirements.txt
   ```

## Multiple ToolR Versions

Each ToolR version has its own virtual environment:

```bash
# Install different versions
mise install toolr@0.11.0
mise install toolr@0.10.1

# Install different packages in each
mise x toolr@0.11.0 -- toolr-pip install requests
mise x toolr@0.10.1 -- toolr-pip install click

# They don't interfere with each other
mise x toolr@0.11.0 -- toolr-pip list  # Shows requests
mise x toolr@0.10.1 -- toolr-pip list  # Shows click
```

## Project-Specific Dependencies

For project-specific ToolR configurations:

### Option 1: Project .tool-versions + requirements.txt

```bash
# In your project
echo "toolr 0.11.0" > .tool-versions

# Create project requirements
cat > toolr-requirements.txt << EOF
# ToolR project dependencies
requests>=2.31.0
pyyaml>=6.0
EOF

# Install when setting up project
mise install
toolr-pip install -r toolr-requirements.txt
```

### Option 2: Project .mise.toml with tasks

```toml
# .mise.toml
[tools]
toolr = "0.11.0"

[tasks.setup]
description = "Setup ToolR environment"
run = "toolr-pip install -r toolr-requirements.txt"

[tasks.clean]
description = "Clean ToolR environment"
run = "toolr-pip uninstall -y -r toolr-requirements.txt"
```

Then:
```bash
cd your-project
mise install
mise run setup
```

## Upgrading Packages

```bash
# Upgrade a specific package
toolr-pip install --upgrade requests

# Upgrade all packages (not recommended)
toolr-pip list --outdated
toolr-pip install --upgrade package1 package2 package3

# Upgrade pip itself
toolr-pip install --upgrade pip
```

## Troubleshooting

### Package Installation Fails

If package installation fails:

```bash
# Upgrade pip first
toolr-pip install --upgrade pip setuptools wheel

# Try installing again
toolr-pip install your-package

# If it's a package with C extensions, you may need build tools
# On Debian/Ubuntu:
sudo apt-get install python3-dev build-essential

# On macOS:
xcode-select --install

# On Windows:
# Install Microsoft C++ Build Tools
```

### Import Error After Installing Package

If ToolR can't find an installed package:

```bash
# Verify package is in ToolR's environment
toolr-pip list | grep package-name

# Check Python path
toolr-python -c "import sys; print('\n'.join(sys.path))"

# Reinstall the package
toolr-pip uninstall package-name
toolr-pip install package-name
```

### Wrong Virtual Environment

If packages appear in the wrong environment:

```bash
# Check which Python is being used
mise which toolr-python

# Verify it's the mise-managed version
# Should be: ~/.local/share/mise/installs/toolr/{version}/bin/toolr-python

# If not, reinstall ToolR
mise uninstall toolr@0.11.0
mise install toolr@0.11.0
```

## Best Practices

### 1. Use Version-Specific Installations

```bash
# Good - specific version
mise use toolr@0.11.0
toolr-pip install requests

# Avoid - floating latest
mise use toolr@latest  # Version can change
```

### 2. Document Dependencies

Always maintain a `requirements.txt` or `pyproject.toml`:

```bash
# Create requirements.txt
toolr-pip freeze > requirements.txt

# Or maintain manually
cat > requirements.txt << EOF
# Data processing
requests>=2.31.0
pandas>=2.0.0

# CLI tools
click>=8.1.0
rich>=13.0.0
EOF
```

### 3. Pin Versions for Stability

```txt
# Good - pinned versions
requests==2.31.0
rich==13.5.0

# Acceptable - minimum versions with flexibility
requests>=2.31.0,<3.0.0
rich>=13.0.0

# Avoid - unpinned (can break)
requests
rich
```

### 4. Test After Installing Packages

```bash
# Install package
toolr-pip install new-package

# Test ToolR still works
toolr --version
toolr --help

# Test your tools still work
toolr your-command
```

## Environment Variables

ToolR's virtual environment respects standard Python environment variables:

```bash
# Install from a private PyPI index
PIP_INDEX_URL=https://pypi.example.com/simple toolr-pip install private-package

# Use a different cache directory
PIP_CACHE_DIR=/tmp/pip-cache toolr-pip install requests

# Disable cache
PIP_NO_CACHE_DIR=1 toolr-pip install requests
```

## Advanced Usage

### Using Poetry or PDM with ToolR

If you want to use Poetry or PDM with ToolR:

```bash
# Install poetry in ToolR's environment
toolr-pip install poetry

# Use it via toolr-python
toolr-python -m poetry init
toolr-python -m poetry add requests
```

### Creating Editable Installations

```bash
# Install a package in development mode
cd /path/to/your-package
toolr-pip install -e .

# Now changes to your package are immediately available
```

### Using Virtual Environment Directly in Scripts

```python
#!/usr/bin/env toolr-python
"""
This script uses ToolR's Python environment
"""
import sys
import requests

def main():
    print(f"Python: {sys.executable}")
    response = requests.get('https://api.github.com')
    print(f"Status: {response.status_code}")

if __name__ == "__main__":
    main()
```

Make it executable:
```bash
chmod +x script.py
./script.py
```

## Summary

- Each ToolR version has its own isolated virtual environment
- Use `toolr-pip` to install packages: `toolr-pip install package-name`
- Use `toolr-python` to run Python in ToolR's environment
- Maintain `requirements.txt` for reproducibility
- Each version is completely independent
- Virtual environments are automatically created during installation

For more information:
- [pip documentation](https://pip.pypa.io/)
- [Python venv documentation](https://docs.python.org/3/library/venv.html)
- [ToolR documentation](https://toolr.readthedocs.io/)