--[[
Main file to load basic variables and mod files
]]--
shonen_joke = {}

shonen_joke.mod_dir = ''..SMODS.current_mod.path
shonen_joke.config  = SMODS.current_mod.config

--Load misc file
assert(SMODS.load_file("atlas.lua"))()
assert(SMODS.load_file("misc.lua"))()
assert(SMODS.load_file("functions.lua"))()
assert(SMODS.load_file("UI.lua"))()
assert(SMODS.load_file("consumable.lua"))()
assert(SMODS.load_file("enhance.lua"))()

--function to load directories
local load_directory = function(dirname, map_item)
  local pfiles = NFS.getDirectoryItems(shonen_joke.mod_dir .. dirname)

  for _, file in ipairs(pfiles) do
    sendDebugMessage ("The file is: "..file)
    local result, load_error = SMODS.load_file(dirname .. "/" ..file)
    if not result then
      sendDebugMessage ("The error is: "..load_error)
    else
      local items = result()
      if items.init then items:init() end

      if items.list and #items.list > 0 then
        for _, item in ipairs(items.list) do
          map_item(item)
        end
      end
    end
  end
end

load_directory("jokers", SMODS.Joker)