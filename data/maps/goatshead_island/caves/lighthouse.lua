-- Lua script of map goatshead_island/caves/lighthouse.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()
  if game:get_value("goatshead_lighthouse_activated") == true then
    torch_1:set_enabled(true)
    torch_2:set_enabled(true)
    torch_3:set_enabled(true)
    torch_4:set_enabled(true)
    torch_5:set_enabled(true)
  end
end

function lighthouse_switch:on_activated()
  game:set_value("goatshead_lighthouse_activated", true)
  sol.audio.play_sound("switch_2")
  torch_1:set_enabled(true)
  torch_2:set_enabled(true)
  torch_3:set_enabled(true)
  torch_4:set_enabled(true)
  torch_5:set_enabled(true)
  game:start_dialog("_goatshead.observations.lighthouse_lit")

end