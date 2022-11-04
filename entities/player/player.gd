extends CharacterBody2D

enum {MOVE}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var state_manager: StateManager = null

func _ready() -> void:
    state_manager = StateManager.new({
        MOVE: Callable(self, "_move_state")
    }, MOVE)


func _physics_process(delta: float) -> void:
    state_manager.physics_process(delta)


func _move_state(delta: float) -> int:
    $AnimatedSprite2D.play("walk")

    velocity.y += gravity * delta
    velocity.y = min(velocity.y, 300)

    var x = Input.get_axis("left", "right")
    var y = Input.get_axis("up", "down")

    if x > 0: $AnimatedSprite2D.flip_h = true
    if x < 0: $AnimatedSprite2D.flip_h = false

    velocity.x = x * 200

    if is_on_floor() && velocity.x == 0:
        $AnimatedSprite2D.play("idle")

    # Do jump!
    if is_on_floor() && Input.is_action_just_pressed("jump"):
        velocity.y = JUMP_VELOCITY

    move_and_slide()

    return MOVE
