local item = ...
local game = item:get_game()

-- Event called when the game is initialized.

function item:on_created()
  item:set_savegame_variable("possession_key_goat_caverns")
  item:set_amount_savegame_variable("amount_key_goat_caverns")
end

function item:on_obtained()
  self:add_amount(1)
end