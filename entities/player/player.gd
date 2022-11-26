extends CharacterBody2D

signal player_hurt(pos: Vector2)
signal player_died()
signal coin_picked_up(total_coins: int)
signal key_picked_up(total_keys: int)

enum {MOVE, HURT, DEAD}

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var GRAVITY: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var coyote: Timer = $CoyoteTimer
@onready var jump_buffer: Timer = $JumpBufferTimer
@onready var invulnerability_timer: Timer = $InvulnerabilityTimer
@onready var dead_timer: Timer = $DeadTimer

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var state_manager: StateManager = null

var last_frame_is_on_floor := false

var can_be_hurt := true :
    get: return can_be_hurt
    set(value):
        can_be_hurt = value
        if not value:
            invulnerability_timer.start()


var coins := 0 :
    get:
        return coins
    set(value):
        coins = value
        emit_signal("coin_picked_up", coins)

var keys := 0 :
    get:
        return keys
    set(value):
        keys = value
        emit_signal("key_picked_up", keys)


func _ready() -> void:
    state_manager = StateManager.new({
        MOVE: Callable(self, "_move_state"),
        HURT: Callable(self, "_hurt_state"),
        DEAD: Callable(self, "_dead_state"),
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

    velocity.x = x * SPEED

    if is_on_floor() && velocity.x == 0:
        animation.play("idle")

    # Do jump!
    if _check_can_jump():
        velocity.y = JUMP_VELOCITY

    last_frame_is_on_floor = is_on_floor()

    if can_be_hurt:
        for i in get_slide_collision_count():
            var col = get_slide_collision(i)
            var collider = col.get_collider()

            if not collider:
                continue

            if collider.is_in_group("jump_pad"):
                if Vector2.UP.dot(col.get_normal()) > 0.1:
                    collider.jump()
                    velocity.y = JUMP_VELOCITY * 1.2

            if collider.is_in_group("locked_doors"):
                if collider.locked:
                    if keys > 0 and collider.has_method("unlock"):
                        keys -= 1
                        collider.unlock()

    move_and_slide()

    return MOVE


func _hurt_state(delta: float) -> int:
    can_be_hurt = false

    if coins == 0:
        dead_pos = global_position
        return state_manager.change_state(DEAD)

    emit_signal("player_hurt", global_position, coins)

    coins = 0

    velocity.y = -300

    return MOVE


var dead_pos: Vector2

func _dead_state(delta: float) -> int:
    if dead_timer.is_stopped():
        dead_timer.start()

    set_collision_layer_value(2, false)
    set_collision_mask_value(6, false)
    global_position = CurveMath.calc_curve(dead_pos, dead_pos + Vector2.UP, dead_timer.wait_time - dead_timer.time_left)

    return DEAD


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


func _on_Coin_coin_picked_up() -> void:
    coins += 1


func _on_Key_key_picked_up() -> void:
    keys += 1


func _on_hit_box_body_entered(body: Node2D) -> void:
    var is_above = global_position.y < body.global_position.y

    # If we hit a monster from above we want to hurt it, otherwise we
    # the player is hurt
    if ['monsters'].all(func(g) : return body.is_in_group(g)) and is_above:
        velocity.y = JUMP_VELOCITY

        if body.has_method("hit"):
            body.hit()
    else:
        state_manager.change_state(HURT)


func _on_dead_timer_timeout() -> void:
    emit_signal("player_died") # Replace with function body.


func _on_invulnerability_timer_timeout() -> void:
    can_be_hurt = true
