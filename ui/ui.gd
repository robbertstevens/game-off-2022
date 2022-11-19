extends CanvasLayer

func get_animation_player() -> AnimationPlayer:
    return $AnimationPlayer

func _on_Coin_coin_picked_up(coins: int) -> void:
    $%CoinAmount.text = str(coins)

