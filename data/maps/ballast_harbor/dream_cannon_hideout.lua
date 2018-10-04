-- Lua script of map ballast_harbor/dream_cannon_hideout.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()


function map:on_started()
  map:set_doors_open("ambush_door")
  if game:get_value("dream_cannons_defeated") == true then pirate_guard:set_enabled(false) end

end


function sensor:on_activated()
  if game:get_value("attacking_dream_cannons") ~= true then
    game:start_dialog("_ballast_harbor.npcs.dream_cannons.captain_1")
    map:close_doors("ambush_door")
    game:set_value("attacking_dream_cannons", true)
  end
end

function dream_cannon_pirate_1:on_dead()
  map:dream_cannons_dead()
end

function dream_cannon_pirate_3:on_dead()
  map:dream_cannons_dead()
end

function dream_cannon_pirate_2:on_dead()
  map:dream_cannons_dead()
end

function map:dream_cannons_dead()
  if map:get_entities_count("dream_cannon_pirate") == 0 then
    map:open_doors("ambush_door")
    game:set_value("dream_cannons_defeated", true)
    local m = sol.movement.create("path")
    m:set_path{0,0}
    m:start(pirate_guard)
    game:set_value("nina_dialog_counter", 4)
  end
end

function pirate_guard:on_interaction()
  if game:get_value("dream_cannons_defeated") == true then
    game:start_dialog("_ballast_harbor.npcs.dream_cannons.captain_3")
  else
    game:start_dialog("_ballast_harbor.npcs.dream_cannons.captain_2")
  end
end