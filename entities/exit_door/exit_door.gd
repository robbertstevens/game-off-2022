extends Node2D


signal door_entered


func _on_hit_box_body_entered(body: Node2D) -> void:
    emit_signal("door_entered")
