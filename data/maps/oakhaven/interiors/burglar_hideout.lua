-- Lua script of map oakhaven/interiors/burglar_hideout.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()
    burglar_3:set_enabled(false)
    burglar_4:set_enabled(false)
  if game:get_value("burglars_saved") == true then
    for enemy in map:get_entities("pirate") do enemy:set_enabled(false) end
    burglar_1:set_enabled(false)
    burglar_2:set_enabled(false)
    burglar_3:set_enabled(true)
    burglar_4:set_enabled(true)
  end

end

function sensor:on_activated()
  if game:get_value("oak_burglars_introduction_to_danger") ~= true then
    game:start_dialog("_oakhaven.npcs.port.burglars.1")
    game:set_value("oak_burglars_introduction_to_danger", true)
  end
end

function burglar_1:on_interaction()
  if game:get_value("burglars_saved") == true then
    game:start_dialog("_oakhaven.npcs.port.burglars.3")
  else
    game:start_dialog("_oakhaven.npcs.port.burglars.yikes")
  end
end

function burglar_2:on_interaction()
  if game:get_value("burglars_saved") == true then
    game:start_dialog("_oakhaven.npcs.port.burglars.2")
  else
    game:start_dialog("_oakhaven.npcs.port.burglars.yikes")
  end
end

function lookout:on_interaction()
  if game:get_value("burglars_saved") ~= true then
    game:start_dialog("_oakhaven.npcs.port.burglars.yikes")
  else
    if game:get_value("oakhaven_palace_secret_passage_knowledge") ~= true then
      game:start_dialog("_oakhaven.npcs.port.burglars.4", function() 
        game:set_value("oakhaven_palace_secret_passage_knowledge", true)
        game:set_value("quest_log_a", "a13")
        sol.audio.play_sound("quest_log")
        game:start_dialog("_game.quest_log_update")
      end)
    else
      game:start_dialog("_oakhaven.npcs.port.burglars.5")
    end
  end
end


for enemy in map:get_entities("pirate") do
  enemy.on_dead = function()
    if not map:has_entities("pirate") then
      game:set_value("burglars_saved", true)
    end
  end
end