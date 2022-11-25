extends Node2D

signal coins_amount_updated(amount: int)
signal level_started(name: String)
signal level_finished
signal game_over

var hit_coin_scn := preload("res://entities/hit_coin/hit_coin.tscn")

@onready var player = $Player
@onready var camera = $Camera2D

@export var level_name := "Dev Level"

func _ready() -> void:
    await get_tree().process_frame
    await get_tree().process_frame

    for coin in get_tree().get_nodes_in_group("coins"):
        coin.connect("coin_picked_up", Callable($Player, "_on_Coin_coin_picked_up"))

    var exit = get_tree().get_first_node_in_group("exit")

    if exit:
        exit.connect("door_entered", Callable(self, "_on_exit_entered"))

    player.connect("player_hurt", Callable(self, "_on_Player_player_hurt"))
    player.connect("coin_picked_up", Callable(self, "_on_coin_picked_up"))

    player.connect("player_died", Callable(self, "_on_player_died"))

    # Set limits
    var map_limits = $TileMap.get_used_rect()
    var map_cellsize = $TileMap.tile_set.tile_size

    camera.limit_left = map_limits.position.x * map_cellsize.x
    camera.limit_right = map_limits.end.x * map_cellsize.x
    camera.limit_top = -99999999 #map_limits.position.y * map_cellsize.y
    camera.limit_bottom = map_limits.end.y * map_cellsize.y

    emit_signal("coins_amount_updated", 0)
    emit_signal("level_started", level_name)


func _physics_process(delta: float) -> void:
    # State 2 is 'DEAD'
    if player.state_manager.is_state(2):
        return

    camera.global_position = lerp(camera.global_position, player.global_position, .7)

func _on_exit_entered() -> void:
    emit_signal("level_finished")


func _on_player_died() -> void:
    emit_signal("game_over")

# Respawn player at the start of the level or last checkpoint
func _respawn_player() -> void:
    pass


func _on_coin_picked_up(coins: int) -> void:
    emit_signal("coins_amount_updated", coins)


func _on_Player_player_hurt(pos: Vector2, coins: int):
    for coin in range(0, coins):
        var c = hit_coin_scn.instantiate()
        c.global_position = pos
        add_child(c)
