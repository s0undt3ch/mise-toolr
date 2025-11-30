-- Copyright 2025 Pedro Algarvio
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- hooks/post_install.lua
-- Performs additional setup after installation
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#postinstall-hook

function PLUGIN:PostInstall(ctx)
    local sdkInfo = ctx.sdkInfo[PLUGIN.name]
    local path = sdkInfo.path
    local version = sdkInfo.version

    -- Create bin directory
    os.execute("mkdir -p " .. path .. "/bin")

    -- Ensure Python is available via mise
    print("Checking for Python...")
    local python_check = os.execute("mise which python3 > /dev/null 2>&1")

    if python_check ~= 0 then
        print("Python not found. Installing Python via mise...")
        print("This may take a few minutes on first installation...")

        -- Install Python 3.11 via mise if not available
        local python_install = os.execute("mise use -g python@3.11 2>&1")
        if python_install ~= 0 then
            error(
                "Failed to install Python via mise. Please install Python 3.11+ manually or run: mise use -g python@3.11"
            )
        end

        -- Verify Python is now available
        local verify = os.execute("mise which python3 > /dev/null 2>&1")
        if verify ~= 0 then
            error("Python installation succeeded but python3 is not available. Please restart your shell.")
        end

        print("Python installed successfully via mise!")
    end

    -- Get the Python path from mise
    local python_cmd
    if RUNTIME.osType == "Windows" then
        python_cmd = "python.exe"
    else
        -- Use mise-managed Python
        local handle = io.popen("mise which python3 2>/dev/null")
        if handle then
            python_cmd = handle:read("*a"):gsub("%s+", "")
            handle:close()
        end

        if not python_cmd or python_cmd == "" then
            python_cmd = "python3"
        end
    end

    -- Create a virtual environment for ToolR
    local venv_path = path .. "/venv"
    print("Creating Python virtual environment for ToolR " .. version .. "...")
    local venv_cmd = python_cmd .. " -m venv " .. venv_path
    local venv_result = os.execute(venv_cmd)
    if venv_result ~= 0 then
        error("Failed to create Python virtual environment. Ensure python3-venv is installed.")
    end

    -- Determine pip path based on OS
    local pip_cmd
    local python_venv_cmd
    if RUNTIME.osType == "Windows" then
        pip_cmd = venv_path .. "\\Scripts\\pip.exe"
        python_venv_cmd = venv_path .. "\\Scripts\\python.exe"
    else
        pip_cmd = venv_path .. "/bin/pip"
        python_venv_cmd = venv_path .. "/bin/python"
    end

    -- Upgrade pip in the virtual environment
    print("Upgrading pip in virtual environment...")
    os.execute(pip_cmd .. " install --quiet --upgrade pip")

    -- Install ToolR using pip
    print("Installing ToolR " .. version .. " from PyPI...")
    local install_cmd = pip_cmd .. " install --quiet toolr==" .. version
    local install_result = os.execute(install_cmd)
    if install_result ~= 0 then
        error("Failed to install toolr " .. version .. " via pip")
    end

    -- Create a requirements.txt file for user customization
    local requirements_file = path .. "/requirements.txt"
    local req_file = io.open(requirements_file, "w")
    if req_file then
        req_file:write("# Add additional Python dependencies here\n")
        req_file:write("# Then run: mise x toolr@" .. version .. " -- pip install -r " .. requirements_file .. "\n")
        req_file:write("# Or use the helper script: " .. path .. "/bin/toolr-pip install <package>\n")
        req_file:write("\n")
        req_file:write("# Example:\n")
        req_file:write("# requests>=2.31.0\n")
        req_file:write("# rich>=13.0.0\n")
        req_file:close()
    end

    -- Create wrapper scripts in bin/
    local toolr_wrapper = path .. "/bin/toolr"
    local pip_wrapper = path .. "/bin/toolr-pip"
    local python_wrapper = path .. "/bin/toolr-python"

    local toolr_content, pip_content, python_content

    if RUNTIME.osType == "Windows" then
        -- Windows batch files
        toolr_content = string.format(
            [[
@echo off
"%s" -m toolr %%*
]],
            python_venv_cmd:gsub("/", "\\")
        )

        pip_content = string.format(
            [[
@echo off
"%s" %%*
]],
            pip_cmd:gsub("/", "\\")
        )

        python_content = string.format(
            [[
@echo off
"%s" %%*
]],
            python_venv_cmd:gsub("/", "\\")
        )

        toolr_wrapper = toolr_wrapper .. ".bat"
        pip_wrapper = pip_wrapper .. ".bat"
        python_wrapper = python_wrapper .. ".bat"
    else
        -- Unix shell scripts
        toolr_content = string.format(
            [[
#!/bin/sh
exec "%s" -m toolr "$@"
]],
            python_venv_cmd
        )

        pip_content = string.format(
            [[
#!/bin/sh
# Helper script to install packages in ToolR's virtual environment
exec "%s" "$@"
]],
            pip_cmd
        )

        python_content = string.format(
            [[
#!/bin/sh
# Helper script to run Python in ToolR's virtual environment
exec "%s" "$@"
]],
            python_venv_cmd
        )
    end

    -- Write toolr wrapper
    local toolr_file = io.open(toolr_wrapper, "w")
    if toolr_file then
        toolr_file:write(toolr_content)
        toolr_file:close()
    else
        error("Failed to create wrapper script at " .. toolr_wrapper)
    end

    -- Write pip wrapper
    local pip_file = io.open(pip_wrapper, "w")
    if pip_file then
        pip_file:write(pip_content)
        pip_file:close()
    end

    -- Write python wrapper
    local python_file = io.open(python_wrapper, "w")
    if python_file then
        python_file:write(python_content)
        python_file:close()
    end

    -- Make wrappers executable on Unix-like systems
    if RUNTIME.osType ~= "Windows" then
        os.execute("chmod +x " .. toolr_wrapper)
        os.execute("chmod +x " .. pip_wrapper)
        os.execute("chmod +x " .. python_wrapper)
    end

    -- Verify installation works
    print("Verifying ToolR installation...")
    local test_cmd
    if RUNTIME.osType == "Windows" then
        test_cmd = toolr_wrapper .. " --version > nul 2>&1"
    else
        test_cmd = toolr_wrapper .. " --version > /dev/null 2>&1"
    end

    local test_result = os.execute(test_cmd)
    if test_result ~= 0 then
        error("ToolR installation verification failed")
    end

    print("ToolR " .. version .. " installed successfully!")
    print("")
    print("Virtual environment location: " .. venv_path)
    print("")
    print("To install additional Python packages:")
    print("  " .. path .. "/bin/toolr-pip install <package-name>")
    print("")
    print("Or add them to: " .. requirements_file)
    print("  Then run: " .. path .. "/bin/toolr-pip install -r " .. requirements_file)
    print("")
    print("To run Python in ToolR's environment:")
    print("  " .. path .. "/bin/toolr-python")
end
