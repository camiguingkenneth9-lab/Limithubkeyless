-- simple, keyless loader
local URL = "https://raw.githubusercontent.com/YourUser/YourRepo/main/main.lua"

local ok, src = pcall(function()
    return game:HttpGet(URL, true)
end)

if not ok then
    warn("[LimitHub-Like] Failed to fetch main.lua:", src)
    return
end

local ok2, err = pcall(function()
    loadstring(src)()
end)

if not ok2 then
    warn("[LimitHub-Like] Failed to run main.lua:", err)
end
