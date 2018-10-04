local enemy = ...


local behavior = require("enemies/lib/archer_teleport")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 10,
  damage = 17,
  normal_speed = 15,
  faster_speed = 35,
  teleport_charge_length = 650,
  teleport_threshold = 70,
  detection_distance = 150,
  attack_sound = "bow",
  projectile_breed = "misc/arrow_4"
}

behavior:create(enemy, properties)

function enemy:on_dead()
  random = math.random(100)
  if random < 20 then
    local map = enemy:get_map()
    local x, y, layer = enemy:get_position()
    map:create_pickable{
     layer = layer,
     x = x,
     y = y,
     treasure_name = "mandrake",
     treasure_variant = 1,
     }
  end
end