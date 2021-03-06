-- Stone shot by Octorok.

local enemy = ...

function enemy:on_created()

  enemy:set_life(1)
  enemy:set_damage(3)
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_size(8, 8)
  enemy:set_origin(4, 4)
  enemy:set_invincible()
  enemy:set_obstacle_behavior("flying")
  enemy:set_attack_consequence("sword", "custom")
end

function enemy:on_obstacle_reached()

  enemy:remove()
end

function enemy:go(direction4)

  local angle = direction4 * math.pi / 2
  local movement = sol.movement.create("straight")
  movement:set_speed(150)
  movement:set_angle(angle)
  movement:set_smooth(false)
  movement:start(enemy)

  enemy:get_sprite():set_direction(direction4)
end

--destroy if hit with sword
--
function enemy:on_custom_attack_received(attack, sprite)

  if attack == "sword" then
  enemy:remove_life(1)
  end
end
--]]