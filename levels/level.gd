extends Node2D

var hit_coin_scn := preload("res://entities/hit_coin/hit_coin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    await get_tree().process_frame

    for coin in get_tree().get_nodes_in_group("coins"):
        coin.connect("coin_picked_up", Callable($Player, "_on_Coin_coin_picked_up"))

    $Player.connect("player_hurt", Callable(self, "_on_Player_player_hurt"))
    $Player.connect("coin_picked_up", Callable(self, "_on_Coin_coin_picked_up"))

    var map_limits = $TileMap.get_used_rect()
    var map_cellsize = $TileMap.tile_set.tile_size

    $Camera2D.limit_left = map_limits.position.x * map_cellsize.x
    $Camera2D.limit_right = map_limits.end.x * map_cellsize.x
    $Camera2D.limit_top = map_limits.position.y * map_cellsize.y
    $Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func _physics_process(delta: float) -> void:
    $Camera2D.global_position = $Player.global_position #lerp($Camera2D.global_position, $Player.global_position, .6)

func _on_Coin_coin_picked_up(total_coins: int):
    # TODO: Make this better
    $UI/VBoxContainer/HBoxContainer/CoinCount/CoinAmount.text = str(total_coins)


func _on_Player_player_hurt(pos: Vector2, coins: int):
    for coin in range(0, coins):
        var c = hit_coin_scn.instantiate()
        c.global_position = pos
        add_child(c)
