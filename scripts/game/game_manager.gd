extends Node

class_name GameManager

enum State{
    Deciding,
    Resolving,
    MovingHorror,
    Victory,
    Defeat
}

const registry_key = "game_manager"
var game_state: State = State.Deciding

signal on_state_changed(state: State)
signal on_move_intention(target: Vector2i)
signal on_move_committed(target: Vector2i)
signal check_fuel
signal on_resolve
signal on_camera_resolve

var defeat_reason: String = ""
var has_checked_fuel: bool

func _ready():
    World.register(registry_key, self)
    on_state_changed.emit(State.Deciding)
    
func process_move_intention(target: Vector2i):
    on_move_intention.emit(target)

func commit_move(target:Vector2i):
    has_checked_fuel = false
    game_state = State.Resolving
    on_state_changed.emit(State.Resolving)
    on_move_committed.emit(target)

func resolve():
    if game_state != State.Resolving:
        printerr("Tried to resolve but was in state '%s'" % game_state)
        return
    on_resolve.emit()
    await on_camera_resolve
    while not has_checked_fuel:
        await get_tree().process_frame
    game_state = State.MovingHorror
    on_state_changed.emit(game_state)

func fuel_checked(has_fuel: bool):
    if not has_fuel:
        lose("OUT OF FUEL!")
        return
    has_checked_fuel = true
    check_fuel.emit()

func camera_resolve():
    on_camera_resolve.emit()

func resolve_horror():
    if game_state != State.MovingHorror:
        printerr("Tried to change from moving-horror but was in state '%s'" % game_state)
        return
    game_state = State.Deciding
    on_state_changed.emit(game_state)
    
func win():
    if game_state != State.Resolving:
        printerr("Tried to win but was in state '%s'" % game_state)
        return
    on_state_changed.emit(State.Victory)

func lose(reason: String):
    if game_state != State.Resolving:
        printerr("Tried to lose but was in state '%s'" % game_state)
        return
    defeat_reason = reason
    game_state = State.Defeat
    on_state_changed.emit(State.Defeat)

    
