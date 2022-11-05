extends CharacterBody2D

enum {MOVE}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY: int = 980

@onready var coyote: Timer = $CoyoteTimer
@onready var jump_buffer: Timer = $JumpBufferTimer

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var state_manager: StateManager = null

var last_frame_is_on_floor := false

func _ready() -> void:
    state_manager = StateManager.new({
        MOVE: Callable(self, "_move_state")
    }, MOVE)


func _physics_process(delta: float) -> void:
    state_manager.physics_process(delta)


func _move_state(delta: float) -> int:
    if not is_on_floor() && last_frame_is_on_floor:
        coyote.start()

    animation.play("walk")

    velocity.y += GRAVITY * delta
    velocity.y = min(velocity.y, 300)

    var x = Input.get_axis("left", "right")
    var y = Input.get_axis("up", "down")

    if x > 0: animation.flip_h = false
    if x < 0: animation.flip_h = true

    # TODO: move_speed
    velocity.x = x * 200

    if is_on_floor() && velocity.x == 0:
        animation.play("idle")

    # Do jump!
    if _check_can_jump():
        velocity.y = JUMP_VELOCITY

    last_frame_is_on_floor = is_on_floor()

    move_and_slide()

    return MOVE

func _check_can_jump() -> bool:
    var jump_key_is_pressed := Input.is_action_just_pressed("jump")

    if not jump_buffer.is_stopped() and is_on_floor():
        jump_buffer.stop()
        return true

    if jump_key_is_pressed and not coyote.is_stopped() and velocity.y > 0:
        coyote.stop()
        return true

    if jump_key_is_pressed and not is_on_floor():
        jump_buffer.start()
        return false

    return jump_key_is_pressed and is_on_floor()
