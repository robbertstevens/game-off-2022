extends Area2D

signal coin_picked_up


@onready var animation := $AnimatedSprite2D


func _ready() -> void:
    animation.frame = randi_range(0, animation.frames.get_frame_count(animation.animation))


func _on_body_entered(body: Node2D) -> void:
    if ['player'].any(func(group): return body.is_in_group(group)):
        emit_signal("coin_picked_up")
        queue_free()
