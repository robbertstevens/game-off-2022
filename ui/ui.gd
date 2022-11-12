extends CanvasLayer


func _on_Coin_coin_picked_up(coins: int) -> void:
    $%CoinAmount.text = str(coins)
