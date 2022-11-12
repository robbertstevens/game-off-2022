extends StaticBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func jump() -> void:
    animation.frame = 0
    animation.play("default")
