extends StaticBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func unlock() -> void:
    animation_player.play("unlock")
    await animation_player.animation_finished
    queue_free()
