-- Initialize hero behavior specific to this quest.

require("scripts/multi_events")

local hero_meta = sol.main.get_metatable("hero")

-- Redefine how to calculate the damage received by the hero.
function hero_meta:on_taking_damage(damage)

--To-Do: make it so explosion damage ignores defense

  -- In the parameter, the damage unit is 1/2 of a heart.
  local game = self:get_game()
  local defense = game:get_value("defense")
    damage = math.floor(damage*2 / defense)
    if damage <= 0 then
      damage = 1
    end
  game:remove_life(damage)
end

return true