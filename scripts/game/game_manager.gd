extends Node

class_name GameManager

enum State{
    Deciding,
    Resolving,
    Victory,
    Defeat
}

const registry_key = "game_manager"
var game_state: State = State.Deciding

signal on_state_changed(state: State)
signal on_move_intention(target: Vector2i)
signal on_move_committed(target: Vector2i)

func _ready():
    World.register(registry_key, self)
    on_state_changed.emit(State.Deciding)
    
func process_move_intention(target: Vector2i):
    on_move_intention.emit(target)

func commit_move(target:Vector2i):
    on_state_changed.emit(State.Resolving)
    on_move_committed.emit(target)

    
