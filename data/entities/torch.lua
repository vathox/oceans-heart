-- A torch that can be lit by fire and unlit by ice.
-- Methods: is_lit(), set_lit()
-- Events: on_lit(), on_unlit()
-- The state is preserved accross maps if the torch has a name, until the world changes.
-- The initial state depends on the direction: unlit if direction 0, lit otherwise.
local torch = ...
local sprite

function torch:on_created()

  torch:set_size(16, 16)
  torch:set_origin(8, 13)
  torch:set_traversable_by(false)
  if torch:get_sprite() == nil then
    torch:create_sprite("entities/torch_short")
  end
  sprite = torch:get_sprite()

  local lit

  local name = torch:get_name()
  if name ~= nil then
    -- See in the game object.
    local game = torch:get_game()
    local map_id = game:get_map():get_id()
    if game.lit_torches_by_map ~= nil and
        game.lit_torches_by_map[map_id] ~= nil then
      lit = game.lit_torches_by_map[map_id][name]
    end
  end

  -- Not info in the game, use the setting of the map.
  if lit == nil then
    lit = torch:get_direction() ~= 0
  end

  sprite:set_direction(0)
  torch:set_lit(lit)
end

function torch:is_lit()
  return sprite:get_animation() == "lit"
end

function torch:set_lit(lit)

  if lit then
    sprite:set_animation("lit")
  else
    sprite:set_animation("unlit")
  end

  local name = torch:get_name()
  if name ~= nil then
    -- Store the state into the game.
    -- game_manager should clear game.lit_torches_by_map when the world changes.
    local game = torch:get_game()
    local map_id = game:get_map():get_id()
    game.lit_torches_by_map = game.lit_torches_by_map or {}
    game.lit_torches_by_map[map_id] = game.lit_torches_by_map[map_id] or {}
    game.lit_torches_by_map[map_id][name] = lit
  end

end

local function on_collision(torch, other, torch_sprite, other_sprite)

  if other:get_type() == "fire" then


      if not torch:is_lit() then
        torch:set_lit(true)
        if torch.on_lit ~= nil then
          torch:on_lit()
        end

        sol.timer.start(other, 50, function()
          other:stop_movement()
          other:get_sprite():set_animation("stopped")
        end)

      end



  elseif other:get_type() == "enemy" then

    local other_model = other:get_breed()
    if other_model == "fireball_red_small" then
      if not torch:is_lit() then
        torch:set_lit(true)
        if torch.on_lit ~= nil then
          torch:on_lit()
        end
      end
      other:remove()
    end
  end
end

torch:set_traversable_by("custom_entity", function(torch, other)
  return other:get_model() == "fire" or other:get_model() == "ice"
end)

torch:add_collision_test("sprite", on_collision)
torch:add_collision_test("overlapping", on_collision)

-- Reset torches info if the world changes.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_map_changed", function(game)

  -- TODO the engine should have an event game:on_world_changed().
  local new_world = map:get_world()
  local world_changed = previous_world == nil or
      new_world == nil or
      new_world ~= previous_world
  if world_changed then
    game.lit_torches_by_map = nil
  end
  game.previous_world = new_world
end)