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

-- hooks/pre_install.lua
-- Returns download information for a specific version
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#preinstall-hook

function PLUGIN:PreInstall(ctx)
    local version = ctx.version

    -- ToolR is a Python package available on PyPI
    -- We'll use pip to install it, so we don't need to download a specific file
    -- Instead, we return metadata that post_install will use

    return {
        version = version,
        -- No URL needed - we'll use pip/uv to install from PyPI in post_install
        note = "Installing ToolR " .. version .. " from PyPI",
    }
end
