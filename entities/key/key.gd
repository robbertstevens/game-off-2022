extends Area2D

signal key_picked_up


func _on_body_entered(body: Node2D) -> void:
    if ['player'].any(func(group): return body.is_in_group(group)):
        @warning_ignore(return_value_discarded)
        emit_signal("key_picked_up")
        queue_free()
