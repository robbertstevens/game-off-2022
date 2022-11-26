extends AnimatableBody2D

signal monster_died(pos: Vector2)

var health = 1

func hit() -> void:
    health -= 1

    if health <= 0:
        emit_signal("monster_died", global_position)
