local item = ...
local game = item:get_game()

local sound_timer

--we don't use this one!

function item:on_created()

  item:set_savegame_variable("possession_bomb_counter")
  item:set_amount_savegame_variable("amount_bomb_counter")
  item:set_assignable(true)
  item:set_amount_savegame_variable("amount_bomb_counter")
  item:set_max_amount(99)
  bomb_max_amount = self:get_max_amount()
end

-- set item to slot 2
function item:on_obtaining()
  game:set_item_assigned(2, self)
  item:set_amount(10)
end

--WE DON'T USE THIS ONE. THIS TRIES TO CREATE THE BOMB AS A CUSTOM ENTITY
-- the problem we get from this is that if you explode the bomb early, there will still be an explosion where the bomb was.
-- Also, it doesn't flash before exploding, but I think we can fix that by adjusting the names of the animations in the sprite
-- to be in line with the bomb flower sprite's names. It's just a mislabeling problem. Maybe.
-- But the extra explosion thing I don't know how to fix. Anyway, use the other bomb counter item.
--And anyway, the only reason I was using a custom entity was because the default timing of the engine bomb
--takes too long to explode. It's unfortunate, but worth the amount of problems it avoids.


-- Called when the player uses the bombs of his inventory by pressing the corresponding item key.
function item:on_using()
  if item:get_amount() == 0 then
    if sound_timer == nil then
      sol.audio.play_sound("wrong")
      sound_timer = sol.timer.start(game, 500, function()
        sound_timer = nil
      end)
    end
  else
    item:remove_amount(1)
    local x, y, layer = item:create_bomb()
    sol.audio.play_sound("bomb")
  end
  item:set_finished()
end

function item:create_bomb()

  local map = item:get_map()
  local hero = map:get_entity("hero")
  local x, y, layer = hero:get_position()
  local direction = hero:get_direction()
  if direction == 0 then
    x = x + 16
  elseif direction == 1 then
    y = y - 16
  elseif direction == 2 then
    x = x - 16
  elseif direction == 3 then
    y = y + 16
  end

--this is the bombs as an explodable, destructable entity.
--[
local bomb = map:create_destructible({
    name = "bomb",
    x = x,
    y = y,
    layer = layer,
    sprite = "entities/bomb",
    can_explode = true,
    can_be_cut = true,
})
  map.current_bombs = map.current_bombs or {}
  map.current_bombs[bomb] = true
--]]

--this is the bombs as a custom entity you can't lift
--[[
  local bomb = map:create_custom_entity({
    x = x,
    y = y,
    layer = layer,
    width = 16,
    height = 16,
    direction = 0,
  })
  map.current_bombs = map.current_bombs or {}
  map.current_bombs[bomb] = true
  local bomb_sprite = bomb:create_sprite("entities/bomb")
  bomb_sprite:set_animation("stopped")
--]]

  local function explode()
    map:create_explosion({
      x = x,
      y = y,
      layer = layer,
    })
    sol.audio.play_sound("explosion")
    bomb:remove()
    map.current_bombs[bomb] = nil
  end

  -- Schedule the explosion
  sol.timer.start(bomb, 1000, function()
--    bomb_sprite:set_animation("stopped_explosion_soon")
    sol.timer.start(bomb, 2000, explode)
  end)
end

function item:remove_bombs_on_map()

  local map = item:get_map()
  if map.current_bombs == nil then
    return
  end
  for bomb in pairs(map.current_bombs) do
    bomb:remove()
  end
  map.current_bombs = {}
--]]
end


--[[
 item:remove_amount(1)
 local hero = self:get_map():get_entity("hero")
  local x, y, layer = hero:get_position()
  local direction = hero:get_direction()
  if direction == 0 then
    x = x + 16
  elseif direction == 1 then
    y = y - 16
  elseif direction == 2 then
    x = x - 16
  elseif direction == 3 then
    y = y + 16
  end

  self:get_map():create_bomb{
    x = x,
    y = y,
    layer = layer
  }

  self:set_finished()
end
--]]
