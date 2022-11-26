extends CanvasLayer


func change_ui(ui: String) -> void:
    for child in get_children():
        child.hide()

    match(ui):
        "main_menu_ui": $MainMenu.show()
        "game_over_ui": $GameOver.show()
        "credits_menu_ui": $CreditsMenu.show()


func _on_coins_amount_updated(coins: int) -> void:
    $%CoinAmount.text = str(coins)


func _on_keys_amount_updated(keys: int) -> void:
    %KeyAmount.text = str(keys)


func _on_level_started(level_name: String) -> void:
    %RichTextLabel.text = level_name
    $LevelStartedContainer/AnimationPlayer.play("LEVEL_INTRO")
    await $LevelStartedContainer/AnimationPlayer.animation_finished
    $CoinCounterContainer.show()
