class_name StateManager extends Node

var _states: Dictionary = {}

var current_state: int
var previous_state: int
var debug := false

func _init(states: Dictionary, starting_state: int, debug_value = false) -> void:
    _states = states
    debug = debug_value
    @warning_ignore(return_value_discarded)
    change_state(starting_state)

func change_state(new_state: int) -> int:
    if not current_state == new_state:
        previous_state = current_state
        current_state = new_state
        if debug:
            print("changed from " + str(previous_state) + " to " + str(current_state))

    return current_state

func physics_process(delta: float) -> void:
    var process_func = _get_state_fn(current_state)

    @warning_ignore(redundant_await)
    var new_state = await process_func.callv([delta])

    if not new_state == current_state:
        @warning_ignore(return_value_discarded)
        change_state(new_state)


func is_state(state: int) -> bool:
    return current_state == state


func _get_state_fn(state: int) -> Callable:
    assert(_states.has(state), "ERROR: State doesn't have a callable")
    assert(_states[state].is_valid(), "ERROR: Something is wrong with the Callable")

    return _states[state]
