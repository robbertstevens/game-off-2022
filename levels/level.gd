extends Node2D

signal coins_amount_updated(amount: int)
signal keys_amount_updated(amount: int)
signal level_started(name: String)
signal level_finished
signal player_died

var hit_coin_scn := preload("res://entities/hit_coin/hit_coin.tscn")
var smoke_scn := preload("res://entities/smoke/smoke.tscn")
var key_scn := preload("res://entities/key/key.tscn")

@onready var player = $Player
@onready var camera = $Camera2D

@export var level_name := "Dev Level"

func _ready() -> void:
    await get_tree().process_frame
    await get_tree().process_frame

    for coin in get_tree().get_nodes_in_group("coins"):
        @warning_ignore(return_value_discarded)
        coin.connect("coin_picked_up", Callable($Player, "_on_Coin_coin_picked_up"))

    for key in get_tree().get_nodes_in_group("keys"):
        @warning_ignore(return_value_discarded)
        key.connect("key_picked_up", Callable($Player, "_on_Key_key_picked_up"))

    for boss in get_tree().get_nodes_in_group("bosses"):
        @warning_ignore(return_value_discarded)
        boss.connect("boss_died", Callable(self, "spawn_smoke"))
        @warning_ignore(return_value_discarded)
        boss.connect("boss_died", Callable(self, "spawn_key"))

    for monster in get_tree().get_nodes_in_group("monsters"):
        @warning_ignore(return_value_discarded)
        monster.connect("monster_died", Callable(self, "spawn_smoke"))

    var exit = get_tree().get_first_node_in_group("exit")

    if exit:
        @warning_ignore(return_value_discarded)
        exit.connect("door_entered", Callable(self, "_on_exit_entered"))

    @warning_ignore(return_value_discarded)
    player.connect("hurt", Callable(self, "_on_Player_hurt"))
    @warning_ignore(return_value_discarded)
    player.connect("coin_picked_up", Callable(self, "_on_coin_picked_up"))
    @warning_ignore(return_value_discarded)
    player.connect("key_picked_up", Callable(self, "_on_key_picked_up"))

    @warning_ignore(return_value_discarded)
    player.connect("died", Callable(self, "_on_player_died"))

    player.coins = 0
    player.keys = 0
    # Set limits
    var map_limits = $TileMap.get_used_rect()
    var map_cellsize = $TileMap.tile_set.tile_size

    camera.limit_left = map_limits.position.x * map_cellsize.x
    camera.limit_right = map_limits.end.x * map_cellsize.x
    camera.limit_top = -99999999 #map_limits.position.y * map_cellsize.y
    camera.limit_bottom = map_limits.end.y * map_cellsize.y

    @warning_ignore(return_value_discarded)
    emit_signal("coins_amount_updated", 0)
    @warning_ignore(return_value_discarded)
    emit_signal("level_started", level_name)


func _physics_process(_delta: float) -> void:
    # State 2 is 'DEAD'
    if player.state_manager.is_state(2):
        return

    camera.global_position = lerp(camera.global_position, player.global_position, .7)

func _on_exit_entered() -> void:
    @warning_ignore(return_value_discarded)
    emit_signal("level_finished")


func _on_player_died() -> void:
    @warning_ignore(return_value_discarded)
    emit_signal("player_died")

# Respawn player at the start of the level or last checkpoint
func _restart_level() -> void:
    pass


func _on_coin_picked_up(coins: int) -> void:
    @warning_ignore(return_value_discarded)
    emit_signal("coins_amount_updated", coins)


func _on_key_picked_up(keys: int) -> void:
    print(keys, "from level")
    @warning_ignore(return_value_discarded)
    emit_signal("keys_amount_updated", keys)


func spawn_smoke(pos: Vector2, smoke_scale = Vector2(1, 1)) -> void:
    var smoke = smoke_scn.instantiate()
    smoke.global_position = pos
    smoke.scale = smoke_scale
    add_child(smoke)


func spawn_key(pos: Vector2, _scale) -> void:
    var key = key_scn.instantiate()
    key.global_position = pos
    @warning_ignore(return_value_discarded)
    key.connect("key_picked_up", Callable($Player, "_on_Key_key_picked_up"))
    add_child(key)

func _on_Player_hurt(pos: Vector2, coins: int):
    for coin in range(0, coins):
        var c = hit_coin_scn.instantiate()
        c.global_position = pos
        add_child(c)
