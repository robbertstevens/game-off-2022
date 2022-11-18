extends AnimatableBody2D

signal died

var health = 1

func hit() -> void:
    health -= 1

    if health <= 0:
        emit_signal("died")
