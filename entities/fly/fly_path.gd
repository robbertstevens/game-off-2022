extends Path2D

enum { LEFT, RIGHT }

@export var move_speed := 100

@onready var follow: PathFollow2D = $PathFollow2D

var state_manager: StateManager = null

func _ready() -> void:
    state_manager = StateManager.new({
        LEFT: Callable(self, "_move_left_state"),
        RIGHT: Callable(self, "_move_right_state")
    }, LEFT)


func _physics_process(delta: float) -> void:
    state_manager.physics_process(delta)


func _move_left_state(delta: float) -> int:
    follow.progress += move_speed * delta
    $PathFollow2D/Fly/AnimatedSprite2D.flip_h = true
    if follow.progress_ratio == 1:
        return RIGHT

    return LEFT


func _move_right_state(delta: float) -> int:
    follow.progress -= move_speed * delta
    $PathFollow2D/Fly/AnimatedSprite2D.flip_h = false
    if follow.progress_ratio == 0:
        return LEFT
    return RIGHT


func _on_fly_monster_died(pos) -> void:
    queue_free()
