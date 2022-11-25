extends CanvasLayer

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func change_scene(scene: Node2D, obj: Node2D) -> void:
    animation_player.play("Resolve")

    await animation_player.animation_finished

    obj.add_child(scene)

    animation_player.play_backwards("Resolve")
