-- The bow has two variants: without arrows or with arrows.
-- This is necessary to allow it to have different icons in both cases.
-- Therefore, the silver bow is implemented as another item (bow_silver),
-- and calls code from this bow.
-- It could be simpler if it was possible to change the icon of items dynamically.

-- Max addendum: no. Different bow/arrow items are different items. They shoot different arrow entities.
-- The only similarity is that the arrow pickups on the map refil all bow types.


local item = ...
local game = item:get_game()

function item:on_created()

  item:set_savegame_variable("possession_bow_fire")
  item:set_amount_savegame_variable("amount_bow")
  item:set_assignable(true)
end
function item:on_started()
  item:set_max_amount(100)
end


-- set to item slot 1
function item:on_obtained()
  game:set_item_assigned(1, self)
--increase bow damage
  bow_damage = game:get_value("bow_damage")
  bow_damage = bow_damage + 2
  game:set_value("bow_damage", bow_damage)
end


-- Using the bow.

function item:on_using()

  -- item is the normal bow, self can be called by other items.

  local map = game:get_map()
  local hero = map:get_hero()

  if self:get_amount() == 0 then
    sol.audio.play_sound("wrong")
    self:set_finished()
  else
    hero:set_animation("bow")

    sol.timer.start(map, 290, function()
    sol.audio.play_sound("bow")
      self:remove_amount(1)
      self:set_finished()
--also, shoot a normal arrow so we can activate switches and stuff.
--actually, this causes a whole bunch of problems. Find a way to make this entity activate switches for real or else avoid that possibility in game.
--      hero:start_bow()

       local x, y = hero:get_center_position()
       local _, _, layer = hero:get_position()
       local arrow = map:create_custom_entity({
         x = x,
         y = y,
         layer = layer,
         width = 16,
         height = 16,
         direction = hero:get_direction(),
         model = "arrow_fire",
       })


      arrow:set_force(self:get_force())
      arrow:set_sprite_id(self:get_arrow_sprite_id())
      arrow:go()

    end)
  end
end

-- Function called when the amount changes.
-- This function also works for the silver bow.
function item:on_amount_changed(amount)

arrows_amount = self:get_amount()

  if self:get_variant() ~= 0 then
    -- update the icon (with or without arrow).
    if amount == 0 then
      self:set_variant(1)
    else
      self:set_variant(2)
    end
  end
end

function item:on_obtaining(variant, savegame_variable)

  local arrow = game:get_item("arrow")

  if variant > 0 then
    self:set_max_amount(50)
    -- Variant 1: bow without arrow.
    -- Variant 2: bow with arrows.
    if variant > 1 then
      self:set_amount(self:get_max_amount())
    end
    arrow:set_obtainable(true)
  else
    -- Variant 0: no bow and arrows are not obtainable.
    self:set_max_amount(0)
    arrow:set_obtainable(false)
  end
end

function item:get_force()

  return 2
end


-- Set the sprite for the arrow entity

function item:get_arrow_sprite_id()
     return "entities/arrow_fire"

end


