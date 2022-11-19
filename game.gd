extends Node2D

@onready var ui: CanvasLayer = $UI
@onready var ui_animation_player: AnimationPlayer = ui.get_animation_player()

var levels: Array = [
    preload("res://levels/dev_level.tscn")
]

var current_level_idx := 0
var current_level_node = null

func _ready() -> void:
    load_level(levels[current_level_idx])


func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept"):
        load_level(levels[current_level_idx])


func load_level(level: Resource) -> void:
    var instance = level.instantiate()
    ui_animation_player.play("Resolve")
    await ui_animation_player.animation_finished

    if current_level_node:
        remove_child(current_level_node)

    add_child(instance)
    current_level_node = instance
    ui_animation_player.play_backwards("Resolve")
