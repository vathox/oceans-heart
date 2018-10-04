
function blacksmith()

 game:start_dialog("_yarrowmouth.npcs.blacksmith", function(answer)
    --sword
    if answer == 2 then
      --have required items
      if game:has_item("sword") == true and game:get_item("coral_ore"):get_amount() >= 1 and game:get_money() >= 50 then
        game:set_value("sword_damage", game:get_value("sword_damage") + 1)
        game:remove_money(50)
        game:get_item("coral_ore"):remove_amount(1)
        game:start_dialog("_goatshead.npcs.palladio.sword_improved")
      else --don't have required items
        game:start_dialog("_game.insufficient_items")
      end

    --bow
    elseif answer == 3 then
      --have required items
      if game:has_item("bow") == true and game:get_item("coral_ore"):get_amount() >= 1 and game:get_money() >= 50 then
        game:set_value("bow_damage", game:get_value("bow_damage") + 1)
        game:remove_money(50)
        game:get_item("coral_ore"):remove_amount(1)
        game:start_dialog("_goatshead.npcs.palladio.bow_improved")
      else --don't have required items
        game:start_dialog("_game.insufficient_items")
      end

    end -- which answer end

  end) --dialog end

end