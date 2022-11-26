extends CharacterBody2D

signal boss_died(pos: Vector2, scale: Vector2)

enum {WALK, ALERTED, CHARGE, CONFUSED}

const MOVE_SPEED = 100.0
const JUMP_VELOCITY = -400.0
const CHARGE_TIME = .5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detect_ray_cast: RayCast2D = $PlayerDetectRayCast
@onready var wall_detect_ray_cast: RayCast2D = $WallDetectRayCast
@onready var alerted_timer: Timer = $AlertedTimer
@onready var confused_timer: Timer = $ConfusedTimer
@onready var invulnerability_timer: Timer = $ConfusedTimer
@onready var emotes: AnimatedSprite2D = $Emotes

var state_manager: StateManager = null

var health := 1

func _ready() -> void:
    state_manager = StateManager.new({
        WALK: Callable(self, "_walk_state"),
        ALERTED: Callable(self, "_alerted_state"),
        CHARGE: Callable(self, "_charge_state"),
        CONFUSED: Callable(self, "_confused_state"),
    }, WALK, true)


func _physics_process(delta: float) -> void:
    if health <= 0:
        die()

    state_manager.physics_process(delta)



func _walk_state(delta: float) -> int:
    emotes.hide()

    if not is_on_floor():
        velocity.y += gravity * delta

    if wall_detect_ray_cast.is_colliding():
        _flip()

    if player_detect_ray_cast.is_colliding():
        return ALERTED
    else:
        if animation.flip_h:
            velocity.x = Vector2.RIGHT.x * MOVE_SPEED
        else:
            velocity.x = Vector2.LEFT.x * MOVE_SPEED


    move_and_slide()

    return WALK


var flip_count = 0

func _alerted_state(delta: float) -> int:
    if alerted_timer.is_stopped():
        _flip()
        alerted_timer.start()
        flip_count += 1

    emotes.play("alerted")
    emotes.show()

    if flip_count > 3:
        flip_count = 0
        return CHARGE

    return ALERTED


func _charge_state(delta: float) -> int:
    emotes.hide()
    if wall_detect_ray_cast.is_colliding():
        return CONFUSED

    velocity.x = player_detect_ray_cast.target_position.normalized().x * 400

    move_and_slide()

    return CHARGE


func _confused_state(delta: float) -> int:
    if confused_timer.is_stopped():
        hit()
        confused_timer.start()

    emotes.play("confused")
    emotes.show()

    return CONFUSED


func _flip() -> void:
    animation.flip_h = !animation.flip_h
    if animation.flip_h:
        player_detect_ray_cast.target_position = Vector2.RIGHT * 100
        wall_detect_ray_cast.target_position = Vector2.RIGHT * 25
    else:
        player_detect_ray_cast.target_position = Vector2.LEFT * 100
        wall_detect_ray_cast.target_position = Vector2.LEFT * 25


func _on_confused_timer_timeout() -> void:
    state_manager.change_state(WALK)


func hit() -> void:
    if invulnerability_timer.is_stopped():
        invulnerability_timer.start()

        health -= 1
    else:
        print("cant touch this tudududud")


func die() -> void:
    emit_signal("boss_died", global_position, animation.scale)
    queue_free()
