extends AnimatedSprite2D

var start := Vector2.ZERO
var target := Vector2.ZERO

@onready var timer := $Timer


func _ready() -> void:
    start = global_position
    target = _target(start, 70)


func _physics_process(_delta: float) -> void:
    global_position = CurveMath.calc_curve(start, target, timer.wait_time - timer.time_left)


func _target(pos, radius) -> Vector2:
    var offset_x = randi_range(-radius, radius)
    var offset_y = randi_range(-radius, radius)

    return Vector2(pos.x + offset_x, pos.y + offset_y)


func _on_timer_timeout() -> void:
    queue_free()
