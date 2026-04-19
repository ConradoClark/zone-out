extends Node

class_name GameOver

@export var things_to_hide: Array[Control]
@export var gameover_window: Control
@export var lost_animation: TweenExecutor
@export var fail_reason: Label


var game_manager: GameManager

func _ready():
    World.require(GameManager.registry_key, _on_game_manager)
    
func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_state_changed.connect(_on_state_changed)
    
func _on_state_changed(state: GameManager.State):
    if state != GameManager.State.Defeat: return
    for thing in things_to_hide:
        thing.visible = false
    gameover_window.visible = true
    fail_reason.text = game_manager.defeat_reason
