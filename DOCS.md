# Documentation Index

Welcome to the mise-toolr documentation! This index helps you find the right documentation for your needs.

## 📚 Quick Navigation

### Getting Started
1. **[README.md](README.md)** - Start here! Overview and main documentation
2. **[INSTALL.md](INSTALL.md)** - Detailed installation instructions
3. **[QUICKSTART.md](QUICKSTART.md)** - Get up and running in minutes

### Essential Guides
- **[FAQ.md](FAQ.md)** - Frequently asked questions and troubleshooting
- **[VIRTUALENV.md](VIRTUALENV.md)** - Managing Python packages and virtual environments

### For Contributors
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute to the plugin (includes technical implementation details)

---

## 📖 Documentation by Topic

### Installation

**New to mise-toolr?** → [QUICKSTART.md](QUICKSTART.md)

**Detailed installation** → [INSTALL.md](INSTALL.md)
- Prerequisites
- Step-by-step installation
- Platform-specific notes
- Troubleshooting

**Common issues** → [FAQ.md](FAQ.md#installation)

### Using ToolR

**Basic usage** → [README.md](README.md#usage)
- Running ToolR commands
- Checking versions
- Getting help

**ToolR documentation** → [ToolR Docs](https://toolr.readthedocs.io/)
- Creating tools
- Command groups
- Advanced features

### Python Package Management

**Installing packages** → [VIRTUALENV.md](VIRTUALENV.md#installing-additional-python-packages)
- Using `toolr-pip`
- Using `requirements.txt`
- Direct virtual environment access

**Managing dependencies** → [VIRTUALENV.md](VIRTUALENV.md#creating-a-reproducible-environment)
- Exporting package lists
- Project-specific dependencies
- Best practices

**Running Python scripts** → [VIRTUALENV.md](VIRTUALENV.md#running-python-in-toolrs-environment)
- Using `toolr-python`
- Running scripts with dependencies

**Common questions** → [FAQ.md](FAQ.md#python-package-management)

### Version Management

**Multiple versions** → [QUICKSTART.md](QUICKSTART.md#multiple-versions)
- Installing multiple versions
- Project-specific versions
- Switching between versions

**Upgrading** → [FAQ.md](FAQ.md#how-do-i-upgrade-to-a-newer-toolr-version)

### Troubleshooting

**Common issues** → [FAQ.md](FAQ.md#troubleshooting)
- Installation failures
- Command not found
- Package installation issues
- Virtual environment problems

**Installation problems** → [INSTALL.md](INSTALL.md#troubleshooting)
- Python not found
- Plugin not found
- Version conflicts

**Virtual environment issues** → [VIRTUALENV.md](VIRTUALENV.md#troubleshooting)
- Package installation failures
- Import errors
- Wrong environment

### Advanced Topics

**Virtual environment internals** → [VIRTUALENV.md](VIRTUALENV.md#virtual-environment-location)
- Where files are stored
- Direct access
- Environment variables

**Project setup** → [QUICKSTART.md](QUICKSTART.md#project-specific-toolr-version)
- Using `.mise.toml`
- Using `.tool-versions`
- Managing project dependencies

**Contributing** → [CONTRIBUTING.md](CONTRIBUTING.md)
- Development setup
- Making changes
- Testing
- Submitting PRs

---

## 🎯 Common Tasks

### I want to...

**Install ToolR for the first time**
1. Read [QUICKSTART.md](QUICKSTART.md)
2. Run the commands shown
3. Verify with `toolr --version`

**Install Python packages for my ToolR tools**
1. See [VIRTUALENV.md](VIRTUALENV.md#installing-additional-python-packages)
2. Use `toolr-pip install package-name`

**Use different ToolR versions in different projects**
1. See [QUICKSTART.md](QUICKSTART.md#project-specific-toolr-version)
2. Create `.tool-versions` or `.mise.toml` in each project

**Fix installation problems**
1. Check [FAQ.md](FAQ.md#troubleshooting)
2. Check [INSTALL.md](INSTALL.md#troubleshooting)
3. Open an issue if needed

**Understand how the plugin works**
1. Read [README.md](README.md#how-it-works)
2. See [CONTRIBUTING.md](CONTRIBUTING.md#plugin-architecture) for technical details

**Contribute to the plugin**
1. Read [CONTRIBUTING.md](CONTRIBUTING.md)
2. Follow the development setup instructions
3. Submit a PR

---

## 📁 File Descriptions

### User Documentation

| File                      | Purpose                              | Audience  |
|---------------------------|--------------------------------------|-----------|
| [README.md](README.md)    | Main documentation and overview      | Everyone  |
| [INSTALL.md](INSTALL.md)  | Comprehensive installation guide     | New users |
| [QUICKSTART.md](QUICKSTART.md) | Fast-track getting started      | New users |
| [FAQ.md](FAQ.md)          | Common questions and answers         | All users |
| [VIRTUALENV.md](VIRTUALENV.md) | Virtual environment management  | All users |
| [DOCS.md](DOCS.md)        | This file - documentation index      | All users |

### Developer Documentation

| File                                   | Purpose                                        | Audience     |
|----------------------------------------|------------------------------------------------|--------------|
| [CONTRIBUTING.md](CONTRIBUTING.md)     | Contribution guidelines and technical details  | Contributors |

---

## 🔗 External Resources

### ToolR
- **Documentation**: https://toolr.readthedocs.io/
- **Repository**: https://github.com/s0undt3ch/ToolR
- **Issues**: https://github.com/s0undt3ch/ToolR/issues

### mise
- **Documentation**: https://mise.jdx.dev
- **Plugin Development**: https://mise.jdx.dev/tool-plugin-development.html
- **Repository**: https://github.com/jdx/mise

### Plugin
- **Repository**: https://github.com/s0undt3ch/mise-toolr
- **Issues**: https://github.com/s0undt3ch/mise-toolr/issues

---

## 💡 Tips

- **Start with the README**: [README.md](README.md) has the most important information
- **Check the FAQ first**: [FAQ.md](FAQ.md) covers most common questions
- **Use the search**: If reading on GitHub, use Ctrl/Cmd+F to search within files
- **Follow the links**: Documentation is cross-linked for easy navigation
- **Ask questions**: Open an issue if you can't find an answer

---

## 📝 Documentation Standards

All documentation in this project follows these principles:

- **Clear and concise**: Get to the point quickly
- **Examples included**: Show, don't just tell
- **Cross-referenced**: Easy to navigate between related topics
- **Kept up-to-date**: Updated with each release
- **Beginner-friendly**: Assumes minimal prior knowledge

---

## 🤝 Contributing to Documentation

Found a typo? Have a suggestion? Want to improve the docs?

1. Read [CONTRIBUTING.md](CONTRIBUTING.md)
2. Make your changes
3. Submit a PR with clear description
4. Tag it with `documentation` label

Documentation improvements are always welcome!

---

**Last Updated**: 2025
**Plugin Version**: 1.0.0
**ToolR Version**: 0.11.0