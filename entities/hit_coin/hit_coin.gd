extends AnimatedSprite2D

var start := Vector2.ZERO
var target := Vector2.ZERO
@onready var timer := $Timer


func _ready() -> void:
    start = global_position
    target = _target(start, 70)


func _physics_process(delta: float) -> void:
    var p0 = start
    var p1 = start + (target - start) / 2 + Vector2.UP * 80
    var p2 = target

    var m1 = lerp(p0, p1, timer.wait_time - timer.time_left)
    var m2 = lerp(p1, p2, timer.wait_time - timer.time_left)

    var new_pos = lerp(m1, m2, timer.wait_time - timer.time_left)

    global_position = new_pos


func _target(pos, radius) -> Vector2:
    var offset_x = randi_range(-radius, radius)
    var offset_y = randi_range(-radius, radius)

    return Vector2(pos.x + offset_x, pos.y + offset_y)


func _on_timer_timeout() -> void:
    queue_free()
