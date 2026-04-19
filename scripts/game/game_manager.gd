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
signal on_resolve
signal on_camera_resolve

func _ready():
    World.register(registry_key, self)
    on_state_changed.emit(State.Deciding)
    
func process_move_intention(target: Vector2i):
    on_move_intention.emit(target)

func commit_move(target:Vector2i):
    game_state = State.Resolving
    on_state_changed.emit(State.Resolving)
    on_move_committed.emit(target)

func resolve():
    if game_state != State.Resolving:
        printerr("Tried to resolve but was in state '%s'" % game_state)
        return
    on_resolve.emit()
    await on_camera_resolve
    on_state_changed.emit(State.Deciding)

func camera_resolve():
    on_camera_resolve.emit()    
    
func win():
    if game_state != State.Resolving:
        printerr("Tried to win but was in state '%s'" % game_state)
        return
    on_state_changed.emit(State.Victory)

func lose():
    if game_state != State.Resolving:
        printerr("Tried to lose but was in state '%s'" % game_state)
        return
    on_state_changed.emit(State.Defeat)

    
