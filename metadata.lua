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

-- metadata.lua
-- Plugin metadata and configuration
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#metadata-lua

PLUGIN = { -- luacheck: ignore
    -- Required: Tool name (lowercase, no spaces)
    name = "toolr",

    -- Required: Plugin version (not the tool version)
    version = "1.0.0",

    -- Required: Brief description of the tool
    description = "A mise tool plugin for ToolR - In-project CLI tooling support",

    -- Required: Plugin author/maintainer
    author = "s0undt3ch",

    -- Optional: Repository URL for plugin updates
    updateUrl = "https://github.com/s0undt3ch/mise-toolr",

    -- Optional: Minimum mise runtime version required
    minRuntimeVersion = "0.2.0",
}
