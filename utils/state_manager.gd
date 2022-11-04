class_name StateManager extends Node

var _states: Dictionary = {}

var current_state: int
var previous_state: int

func _init(states: Dictionary, starting_state: int) -> void:
    _states = states

    change_state(starting_state)

func change_state(new_state: int) -> int:
    if not current_state == new_state:
        previous_state = current_state
        current_state = new_state

    return current_state

func physics_process(delta: float) -> void:
    var process_func = _get_state_fn(current_state)

    var new_state = process_func.callv([delta])

    if not new_state == current_state:
        change_state(new_state)


func is_state(state: int) -> bool:
    return current_state == state


func _get_state_fn(state: int) -> Callable:
    assert(_states.has(state), "ERROR: State doesn't have a callable")
    assert(_states[state].is_valid(), "ERROR: Something is wrong with the Callable")

    return _states[state]
