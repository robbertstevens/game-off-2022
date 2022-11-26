extends StaticBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

var locked = true

func unlock() -> void:
    if locked:
        locked = false
        animation_player.play("unlock")
        await animation_player.animation_finished
        queue_free()
