-- Lua script of map Yarrowmouth/yarrowmouth_village.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()
  goatshead_teletransport:set_enabled(false)
  oakhaven_teletransport:set_enabled(false)
  to_limestone:set_enabled(false)
  if game:get_value("dream_cannons_defeated") == true then carlov:set_enabled(false) end

  local gm=sol.movement.create("random")
  gm:set_speed(10)
  gm:start(goat)

end


function goatshead_ferry:on_interaction()
  game:start_dialog("_ferries.goatshead", function(answer)
    if answer == 3 then
      if game:get_money() >9 then
        game:remove_money(10)
        goatshead_teletransport:set_enabled(true)
      else
        game:start_dialog("_game.insufficient_funds")
      end
    end
  end)
end

function oakhaven_ferry:on_interaction()
  game:start_dialog("_ferries.oakhaven", function(answer)
    if answer == 3 then
      if game:get_money() >9 then
        game:remove_money(10)
        oakhaven_teletransport:set_enabled(true)
      else
        game:start_dialog("_game.insufficient_funds")
      end
    end
  end)
end

function broken_bird_statue:on_interaction()
  if game:has_item("stone_beak") == true then
    game:start_dialog("_yarrowmouth.observations.broken_bird.2", function(answer)
      if answer == 3 then
        bird_repaired:set_enabled(true)
        map:open_doors("bird_beak_door")
        sol.audio.play_sound("secret")
      end
    end)
  else
    game:start_dialog("_yarrowmouth.observations.broken_bird.1")
  end
end


--armorer pinecone quest
function mera:on_interaction()
  if game:get_value("yarrow_mera_armor_obtained") ~= true then --if you don't already have the armor
  --if you have a pinecone
    if game:has_item("iron_pinecone") == true then
      game:start_dialog("_yarrowmouth.npcs.mera.3", function(answer)

        if answer == 2 then
          if game:get_money() >49 then
            game:remove_money(50)
            game:start_dialog("_yarrowmouth.npcs.mera.4")
            game:set_value("defense", game:get_value("defense") +2)
            game:set_value("yarrow_mera_armor_obtained", true)

          else
            game:start_dialog("_game.insufficient_funds")
          end --end money check
        end --end of answer check

      end) --end of mera.3 dialog


    else --if you don't have the pinecone yet
      game:start_dialog("_yarrowmouth.npcs.mera.1", function(answer)
        game:start_dialog("_yarrowmouth.npcs.mera.2")

      end) --end of how you answer if you want armor
    end--end of if you have pinecone or not
  else --if you have already gotten the armor
    game:start_dialog("_yarrowmouth.npcs.mera.5")
  end
end



function blacksmith:on_interaction()

game:start_dialog("_yarrowmouth.npcs.blacksmith", function(answer)
    --sword
    if answer == 2 then
      --have required items
      if game:has_item("sword") == true and game:get_item("coral_ore"):get_amount() >= 1 and game:get_money() >= 50 then
        game:set_value("sword_damage", game:get_value("sword_damage") + 1)
        game:remove_money(50)
        game:get_item("coral_ore"):remove_amount(1)
        game:start_dialog("_goatshead.npcs.palladio.sword_improved")
      else --don't have required items
        game:start_dialog("_game.insufficient_items")
      end

    --bow
    elseif answer == 3 then
      --have required items
      if game:has_item("bow") == true and game:get_item("coral_ore"):get_amount() >= 1 and game:get_money() >= 50 then
        game:set_value("bow_damage", game:get_value("bow_damage") + 1)
        game:remove_money(50)
        game:get_item("coral_ore"):remove_amount(1)
        game:start_dialog("_goatshead.npcs.palladio.bow_improved")
      else --don't have required items
        game:start_dialog("_game.insufficient_items")
      end

    end -- which answer end

  end) --dialog end

--local shop = require("scripts/shops/blacksmith")
--shop:blacksmith()
end --blacksmith interaction end