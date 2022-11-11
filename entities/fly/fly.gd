extends AnimatableBody2D

signal died

func die() -> void:
    emit_signal("died")
