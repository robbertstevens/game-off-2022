extends Area2D

signal coin_picked_up

func _on_body_entered(body: Node2D) -> void:
    # TODO: Play sound
    emit_signal("coin_picked_up")
    queue_free()
