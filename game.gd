extends Node2D

@onready var ui: CanvasLayer = $UI

var levels: Array[PackedScene] = [
#    preload("res://levels/dev_level.tscn"),
#    preload("res://levels/level_one.tscn"),
#    preload("res://levels/level_two.tscn"),
#    preload("res://levels/level_three.tscn"),
    preload("res://levels/level_four.tscn"),
]

var current_level_idx := 0
var current_level_node = null
var state_manager : StateManager = null

func _ready() -> void:
    RenderingServer.set_default_clear_color(Color("dff6f5"))

    ui.change_ui("main_menu_ui")


func reset() -> void:
    current_level_idx = 0


func load_level(level: PackedScene) -> void:
    if current_level_node:
        remove_child(current_level_node)
    var instance = level.instantiate()
    @warning_ignore(return_value_discarded)
    instance.connect("coins_amount_updated", Callable(ui, "_on_coins_amount_updated"))
    @warning_ignore(return_value_discarded)
    instance.connect("keys_amount_updated", Callable(ui, "_on_keys_amount_updated"))
    @warning_ignore(return_value_discarded)
    instance.connect("level_started", Callable(ui, "_on_level_started"))
    @warning_ignore(return_value_discarded)
    instance.connect("level_finished", Callable(self, "_on_level_finished"))
    @warning_ignore(return_value_discarded)
    instance.connect("game_over", Callable(self, "_on_game_over"))
    current_level_node = instance

    SceneTransition.change_scene(instance, self)

    ui.change_ui("game_ui")


func _on_game_over() -> void:
    remove_child(current_level_node)

    ui.change_ui("game_over_ui")

func _on_level_finished() -> void:
    current_level_idx += 1

    if current_level_idx > len(levels) - 1:
        remove_child(current_level_node)
        ui.change_ui("credits_menu_ui")
        return

    load_level(levels[current_level_idx])


func _on_start_button_pressed() -> void:
    load_level(levels[current_level_idx])


func _on_re_start_button_pressed() -> void:
    reset()
    ui.change_ui("main_menu_ui")
