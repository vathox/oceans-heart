local enemy = ...

local behavior = require("enemies/lib/underground_toward_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 8,
  damage = 10,
  normal_speed = 50,
  faster_speed = 75,
  detection_distance = 65,
  time_aboveground = 3000,
  burrow_deviation = 4000,  
}

behavior:create(enemy, properties)

function enemy:on_dead()
  random = math.random(100)
  if random < 10 then
    local map = enemy:get_map()
    local x, y, layer = enemy:get_position()
    map:create_pickable{
     layer = layer,
     x = x,
     y = y,
     treasure_name = "monster_guts",
     treasure_variant = 1,
     }
  end
end