-- Lua script of map Yarrowmouth/interiors/briarwood_distillery.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()
  if game:get_value("talked_to_jerah_in_the_grove") ~= true then jerah:set_enabled(false) end

end


function olin:on_interaction()
  if game:get_value("have_juniper_key") == true then

    game:start_dialog("_yarrowmouth.npcs.tavern.Olin.3")

  else

    if game:get_value("seen_spruce_sanctuary") == true then
      game:start_dialog("_yarrowmouth.npcs.tavern.Olin.2", function()
        game:set_value("have_juniper_key", true)
      end)
    else
      game:start_dialog("_yarrowmouth.npcs.tavern.Olin.1")
    end

  end --end of has item function

end


function jerah:on_interaction()
  game:start_dialog("_yarrowmouth.npcs.tavern.jerah.3")
end


--Rohit - Meadery Quest
function rohit:on_interaction()
  rdc = game:get_value("rohit_dialog_counter")
  if rdc == nil then
    game:start_dialog("_yarrowmouth.npcs.tavern.rohit.1", function(answer)
      if answer == 2 then
        game:start_dialog("_yarrowmouth.npcs.tavern.rohit.2")
        game:set_value("you_got_mushroom_spot_key", true)
        game:set_value("rohit_dialog_counter", 1)
      end
    end)

  elseif rdc == 1 then
    game:start_dialog("_yarrowmouth.npcs.tavern.rohit.3")

  --if you've found the bait, but not the cabin
  elseif rdc == 2 then
    game:start_dialog("_yarrowmouth.npcs.tavern.rohit.4", function() game:add_money(65) end)
    game:set_value("rohit_dialog_counter", 3)

  elseif rdc == 3 then
    game:start_dialog("_yarrowmouth.npcs.tavern.rohit.5")

  elseif rdc == 4 then
    game:start_dialog("_yarrowmouth.npcs.tavern.rohit.6")
    game:set_value("rohit_dialog_counter", 5)
    game:set_value("suspect_michael", true)

  elseif rdc == 5 then
    game:start_dialog("_yarrowmouth.npcs.tavern.rohit.7")

  elseif rdc == 6 then
    game:start_dialog("_yarrowmouth.npcs.tavern.rohit.8", function() game:add_money(110) end)
    game:set_value("rohit_dialog_counter", 7)
    game:set_value("briarwood_distillery_quest_complete", true)

  elseif rdc == 7 then
    game:start_dialog("_yarrowmouth.npcs.tavern.rohit.9")

  end --end of rohit dialog counter if/then
end