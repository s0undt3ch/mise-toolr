# Contributing to mise-toolr

Thank you for your interest in contributing to the mise-toolr plugin! This document provides guidelines and
instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Plugin Architecture](#plugin-architecture)
- [Coding Standards](#coding-standards)

## Code of Conduct

This project follows a standard code of conduct. Please be respectful and constructive in all interactions.

## Getting Started

### Prerequisites

- [mise](https://mise.jdx.dev) installed
- Git
- Python 3.11 or later
- Basic knowledge of Lua (for plugin development)
- Familiarity with ToolR (helpful but not required)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/mise-toolr.git
   cd mise-toolr
   ```
3. Add the upstream remote:
   ```bash
   git remote add upstream https://github.com/s0undt3ch/mise-toolr.git
   ```

## Development Setup

### 1. Link the Plugin Locally

```bash
# Link the plugin for development
mise plugin link toolr .
```

### 2. Install Development Tools

```bash
# Install mise tools defined in mise.toml
mise install

# Install pre-commit hooks (optional but recommended)
hk install
```

### 3. Test the Plugin

```bash
# Install a ToolR version
mise install toolr@0.11.0

# Test it works
mise exec toolr@0.11.0 -- toolr --version

# Run the test suite
mise run test
```

## Making Changes

### Branch Naming

Use descriptive branch names:
- `feature/add-xyz` - New features
- `fix/bug-description` - Bug fixes
- `docs/update-readme` - Documentation updates
- `refactor/improve-xyz` - Code refactoring

Example:
```bash
git checkout -b feature/add-version-caching
```

### Commit Messages

Follow conventional commit format:

```
type(scope): brief description

Longer description if needed.

Fixes #123
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Test changes
- `chore`: Maintenance tasks

Examples:
```bash
git commit -m "feat(hooks): add version caching support"
git commit -m "fix(post_install): handle Windows path separators correctly"
git commit -m "docs(readme): add troubleshooting section"
```

### What to Change

Common areas for contribution:

1. **Bug Fixes**
   - Installation issues on specific platforms
   - Version detection problems
   - Path handling issues

2. **Features**
   - Support for additional ToolR installation methods
   - Performance improvements
   - Better error messages

3. **Documentation**
   - Clarify installation steps
   - Add examples
   - Improve troubleshooting guide

4. **Testing**
   - Add test cases
   - Improve CI/CD
   - Test on different platforms

## Testing

### Manual Testing

```bash
# Link the plugin
mise plugin link toolr .

# Clear cache to ensure fresh install
mise cache clear

# Install a version
mise install toolr@0.11.0

# Test basic functionality
mise exec toolr@0.11.0 -- toolr --version
mise exec toolr@0.11.0 -- toolr --help

# Test with different versions
mise install toolr@0.10.1
mise exec toolr@0.10.1 -- toolr --version
```

### Automated Testing

```bash
# Run the test suite
mise run test

# Run linting
mise run lint

# Run all CI checks
mise run ci
```

### Test on Different Platforms

If possible, test on:
- macOS (Intel and Apple Silicon)
- Linux (x86_64 and aarch64)
- Windows

Use GitHub Actions for cross-platform testing if you can't test locally.

## Submitting Changes

### Before Submitting

1. **Update documentation** if needed:
   - README.md
   - INSTALL.md
   - QUICKSTART.md
   - Code comments

2. **Run tests and linting**:
   ```bash
   mise run ci
   ```

3. **Test manually**:
   ```bash
   mise cache clear
   mise install toolr@latest
   mise exec toolr@latest -- toolr --version
   ```

4. **Update CHANGELOG** if applicable

### Pull Request Process

1. **Push your changes**:
   ```bash
   git push origin feature/your-feature
   ```

2. **Create a Pull Request** on GitHub with:
   - Clear title describing the change
   - Description of what changed and why
   - Reference to related issues (if any)
   - Screenshots (for UI/output changes)
   - Testing performed

3. **PR Template**:
   ```markdown
   ## Description
   Brief description of changes

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Refactoring

   ## Testing
   - [ ] Tested on macOS
   - [ ] Tested on Linux
   - [ ] Tested on Windows
   - [ ] All tests pass
   - [ ] Linting passes

   ## Related Issues
   Fixes #123
   ```

4. **Respond to feedback** from reviewers

5. **Keep your PR updated**:
   ```bash
   # Sync with upstream
   git fetch upstream
   git rebase upstream/main
   git push origin feature/your-feature --force-with-lease
   ```

## Plugin Architecture

### File Structure

```
mise-toolr/
├── hooks/
│   ├── available.lua       # Fetches available versions
│   ├── pre_install.lua     # Prepares for installation
│   ├── post_install.lua    # Performs installation
│   └── env_keys.lua        # Sets environment variables
├── metadata.lua            # Plugin metadata
├── mise-tasks/
│   └── test               # Test script
├── .github/
│   └── workflows/         # CI/CD workflows
└── docs/                  # Documentation
```

### Hook Execution Flow

```
mise install toolr@0.11.0
         ↓
    available.lua  ← Fetch versions from GitHub
         ↓
   pre_install.lua ← Return metadata
         ↓
  post_install.lua ← Create venv, install via pip
         ↓
    env_keys.lua   ← Setup PATH
         ↓
    Installation complete
```

### Key Files

1. **hooks/available.lua**
   - Fetches versions from GitHub Releases API: `https://api.github.com/repos/s0undt3ch/ToolR/releases`
   - Returns array of version objects
   - Strips 'v' prefix from version tags
   - Handles pre-releases

2. **hooks/pre_install.lua**
   - Returns metadata for installation
   - No download needed (uses PyPI)
   - Actual installation happens in post_install via pip

3. **hooks/post_install.lua**
   - Ensures Python 3.11+ is available (auto-installs via mise if needed)
   - Creates Python virtual environment in `{install_path}/venv`
   - Installs ToolR via pip: `pip install toolr=={version}`
   - Creates wrapper scripts in `bin/`:
     - Unix/Linux/macOS: Shell script that executes `python -m toolr`
     - Windows: Batch file that executes `python.exe -m toolr`
   - Makes wrapper executable on Unix-like systems
   - Verifies installation with `--version` check

4. **hooks/env_keys.lua**
   - Adds `{install_path}/bin` to PATH
   - Wrapper scripts handle venv activation automatically

### Installation Method: PyPI via pip

ToolR is distributed as Python wheels on both PyPI and GitHub Releases. This plugin uses the PyPI approach because:

1. **Simpler**: No need to detect platform/architecture/Python version
2. **Standard**: Uses pip, the standard Python package installer
3. **Reliable**: PyPI is the authoritative source for Python packages
4. **Version-specific**: Each mise version gets its own isolated virtual environment

### Virtual Environment Isolation

Each ToolR version installed via mise gets its own isolated Python virtual environment:

```
~/.local/share/mise/installs/toolr/
├── 0.11.0/
│   ├── venv/              # Python virtual environment
│   │   ├── bin/
│   │   │   ├── python     # Python interpreter
│   │   │   ├── pip        # pip package manager
│   │   │   └── toolr      # Actual toolr executable
│   │   └── lib/           # Python packages
│   └── bin/
│       └── toolr          # Wrapper script (calls venv/bin/python -m toolr)
├── 0.10.1/
│   ├── venv/
│   └── bin/
└── ...
```

This approach ensures:
- Complete isolation between versions
- No conflicts with system Python or other ToolR installations
- Each version can have its own Python dependencies

### Platform Support

The plugin supports all platforms that ToolR supports:
- **Linux**: x86_64, aarch64 (glibc and musl)
- **macOS**: x86_64, arm64 (Apple Silicon)
- **Windows**: amd64

Requirements:
- Python 3.11 or later (auto-installed via mise if not available)
- `python3` command available (or `python` on Windows)

## Coding Standards

### Lua Code

- Use 4 spaces for indentation
- Follow existing code style
- Add comments for complex logic
- Use descriptive variable names
- Handle errors gracefully

Example:
```lua
-- Good
local function fetch_versions()
    local resp, err = http.get({ url = repo_url })
    if err ~= nil then
        error("Failed to fetch versions: " .. err)
    end
    return resp
end

-- Bad
local function f()
    local r = http.get({url=u})
    return r
end
```

### Shell Scripts

- Use `set -euo pipefail` for safety
- Quote variables
- Use meaningful variable names
- Add comments

Example:
```bash
#!/usr/bin/env bash
set -euo pipefail

# Good
version="${1:-latest}"
echo "Installing version: ${version}"

# Bad
v=$1
echo Installing $v
```

### Linting

Run linters before committing:

```bash
# Lua linting
mise run lint

# Or manually
stylua --check .
luacheck .
```

## Documentation Style

- Use clear, concise language
- Include examples
- Use code blocks with proper syntax highlighting
- Keep line length reasonable (~80-100 chars)
- Use proper Markdown formatting

## Questions?

- Open an issue for questions
- Check existing issues and PRs
- Review [ToolR documentation](https://toolr.readthedocs.io/)
- Review [mise plugin development guide](https://mise.jdx.dev/tool-plugin-development.html)

## License

By contributing, you agree that your contributions will be licensed under the Apache License, Version 2.0.