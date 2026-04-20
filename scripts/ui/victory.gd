extends Node

class_name Victory

@export var things_to_hide: Array[Control]
@export var victory_window: Control
@export var win_animation: TweenExecutor

var game_manager: GameManager

func _ready():
    World.require(GameManager.registry_key, _on_game_manager)
    
func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_state_changed.connect(_on_state_changed)
    
func _on_state_changed(state: GameManager.State):
    if state != GameManager.State.Victory: return
    for thing in things_to_hide:
        thing.visible = false
    victory_window.visible = true
