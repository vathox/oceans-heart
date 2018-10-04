-- Lua script of map Yarrowmouth/kingsdown.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()
  if game:get_value("kingsdown_island_unlocked") == true then
    block_statue_1:set_enabled(false)
    block_statue_2:set_enabled(false)
  end

  if game:get_value("oakhaven_ferries_activated") == true then lighthouse_light:set_enabled(true) end
  if game:get_value("yarrow_village_pirate_guard_left") == true then pirate_guard:set_enabled(false) end

  if game:get_value("nina_dialog_counter") ~= 2 then nina:set_enabled(false) end

end


function secret_keyhole:on_interaction()
  if game:has_item("key_kingsdown") == true and game:get_value("kingsdown_island_unlocked") ~= true then
    game:start_dialog("_yarrowmouth.observations.secret_switch.2", function(answer)
      if answer == 3 then
        block_statue_1:set_enabled(false)
        block_statue_2:set_enabled(false)
        sol.audio.play_sound("switch")
        sol.audio.play_sound("secret")
        game:start_dialog("_game.quest_log_update", function() sol.audio.play_sound("quest_log") end)
        game:set_value("kingsdown_island_unlocked", true)
        game:set_value("quest_log_a", "a7")
        game:set_value("quest_log_b", 0)
      end
    end) --end of answer function

  else --don't have the key yet
    game:start_dialog("_yarrowmouth.observations.secret_switch.1")

  end
end


function pirate_guard:on_interaction()
  if game:get_value("going_to_meet_carlov_pirates") == true then
    game:start_dialog("_yarrowmouth.npcs.guard_pirate.2")
    local m = sol.movement.create("path")
    m:set_path{2,2}
    m:set_speed(20)
    m:start(pirate_guard, function()
      pirate_guard:set_enabled(false)
      game:set_value("yarrow_village_pirate_guard_left", true)
    end)

  else --if you haven't already talked to Nina
    game:start_dialog("_yarrowmouth.npcs.guard_pirate.1")
  end
end


function nina:on_interaction()
  if game:get_value("nina_dialog_counter") == 2 then
    game:start_dialog("_yarrowmouth.npcs.nina.marsh1")
    game:set_value("nina_dialog_counter", 3)
  elseif game:get_value("nina_dialog_counter") == 3 then
    game:start_dialog("_yarrowmouth.npcs.nina.6")
  end

end