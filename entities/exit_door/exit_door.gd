extends Node2D


signal door_entered


func _on_hit_box_body_entered(_body: Node2D) -> void:
    @warning_ignore(return_value_discarded)
    emit_signal("door_entered")
