hs.loadSpoon("EmmyLua")

local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

local function setAlacrittyTheme(theme)
  local path = os.getenv("HOME") .. "/.config/alacritty/alacritty.toml"
  local content = nil
  local file = io.open(path, "r")
  if file then
    content = file:read("*a")
    file:close()
  else
    hs.alert.show("Error opening alacritty config at " .. path)
    return
  end

  file = io.open(path, "w")
  if file then
    content = content:gsub("gruvbox_[%w]+%.toml", "gruvbox_" .. theme .. ".toml")
    local _, error = file:write(content)
    if error then
      hs.alert.show(error)
    end

    file:close()
  else
    hs.alert.show("Error opening alacritty config at " .. path)
  end
end

local function reloadNvimConfig()
  local mp = require("MessagePack")
  local message = mp.pack({ 0, 0, "nvim_command", { "luafile $MYVIMRC" } })

  local handle = io.popen("lsof -U -a -p $(pgrep -d, nvim) | awk '{print $8}' | grep '^/'")
  if handle then
    for socket_path in handle:lines() do
      local client = hs.socket.new()
      assert(client:connect(socket_path, function()
        client:write(message)
      end))
    end
  end
end

local function themeChangedCallback()
  local appearance = hs.host.interfaceStyle() or "Light"
  if appearance == "Light" then
    setAlacrittyTheme("light")
  else
    setAlacrittyTheme("dark")
  end

  reloadNvimConfig()
end

assert(
  hs.distributednotifications.new(themeChangedCallback, "AppleInterfaceThemeChangedNotification")
):start()

local function mapCmdTab(event)
  local flags = event:getFlags()
  local chars = event:getCharacters()
  if chars == "\t" and flags:containExactly({ "cmd" }) then
    return true
  elseif chars == string.char(25) and flags:containExactly({ "cmd", "shift" }) then
    return true
  end
end
hs.eventtap.new({ hs.eventtap.event.types.keyDown }, mapCmdTab):start()
