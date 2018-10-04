local item = ...
local game = item:get_game()

-- Event called when the game is initialized.

function item:on_created()
  item:set_savegame_variable("possession_key_goat_tunnels")
  item:set_amount_savegame_variable("amount_key_goat_tunnels")
end

function item:on_obtained()
  self:add_amount(1)
end