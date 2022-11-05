extends Node2D

var hit_coin_scn := preload("res://entities/hit_coin/hit_coin.tscn")

var coins := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    for coin in get_tree().get_nodes_in_group("coins"):
        coin.connect("coin_picked_up", Callable(self, "_on_Coin_coin_picked_up"))

    $Player.connect("player_hurt", Callable(self, "_on_Player_player_hurt"))

func _on_Coin_coin_picked_up():
    coins += 1
    %CoinAmount.text = str(coins)


func _on_Player_player_hurt(pos: Vector2):
    for coin in range(0, coins):
        var c = hit_coin_scn.instantiate()
        c.global_position = pos
        add_child(c)
