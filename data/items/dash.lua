local item = ...
local game = item:get_game()

-- Event called when the game is initialized.
function item:on_created()
  item:set_savegame_variable("possession_dash")
  item:set_assignable(true)
end

function item:on_obtained()
  game:set_item_assigned(2, self)
end

-- Event called when the hero is using this item.
function item:on_using()
  local hero = game:get_hero()
  local dir = hero:get_direction()
  if dir == 1 then dir = (math.pi/2) elseif dir == 2 then dir = math.pi elseif dir == 3 then dir = (3*math.pi/2) end
  local m = sol.movement.create("straight")
  m:set_angle(dir)
  m:set_speed(350)
  m:set_max_distance(64)
  m:set_smooth(true)
  hero:freeze()
  hero:set_blinking(true, 200)
  sol.audio.play_sound("cane")
  m:start(hero, function() hero:unfreeze() end)
  game:simulate_command_pressed("attack")
  hero:set_invincible(true, 300)

  function m:on_obstacle_reached()
    hero:unfreeze()
  end

  item:set_finished()
end

-- Event called when a pickable treasure representing this item
-- is created on the map.
function item:on_pickable_created(pickable)

  -- You can set a particular movement here if you don't like the default one.
end
