local enemy = ...

local behavior = require("enemies/lib/soldier")

local properties = {
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 4,
  damage = 2,
  normal_speed = 16,
  faster_speed = 55,
  distance = 100,
}

behavior:create(enemy, properties)