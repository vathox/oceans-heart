local item = ...
local game = item:get_game()

function item:on_created()

  self:set_can_disappear(false)
  self:set_brandish_when_picked(true)
  item:set_sound_when_brandished("piece_of_heart")
  item:set_sound_when_picked("piece_of_heart")
end

function item:on_obtaining(variant, savegame_variable)

  local vol = sol.audio.get_music_volume()
  sol.audio.set_music_volume(vol - 40)
  sol.timer.start(100, function() sol.audio.set_music_volume(vol) end)
  game:add_max_life(2)
  game:set_life(game:get_max_life())

end
