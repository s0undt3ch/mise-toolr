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

-- hooks/available.lua
-- Returns a list of available versions for the tool
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#available-hook

function PLUGIN:Available(ctx)
    local http = require("http")
    local json = require("json")

    -- Use GitHub Releases API for ToolR
    local repo_url = "https://api.github.com/repos/s0undt3ch/ToolR/releases"

    -- mise automatically handles GitHub authentication - no manual token setup needed
    local resp, err = http.get({
        url = repo_url,
    })

    if err ~= nil then
        error("Failed to fetch versions: " .. err)
    end
    if resp.status_code ~= 200 then
        error("GitHub API returned status " .. resp.status_code .. ": " .. resp.body)
    end

    local releases = json.decode(resp.body)
    local result = {}

    -- Process releases
    for _, release in ipairs(releases) do
        local version = release.tag_name

        -- Clean up version string (remove 'v' prefix if present)
        version = version:gsub("^v", "")

        local is_prerelease = release.prerelease or false
        local note = is_prerelease and "pre-release" or nil

        table.insert(result, {
            version = version,
            note = note,
        })
    end

    return result
end
