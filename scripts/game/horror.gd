extends Node

class_name Horror

@export var grid_pos: Vector2i

var game_manager: GameManager

func _ready():
    World.require(GameManager.registry_key, _on_game_manager)
    
func _on_game_manager(obj: GameManager):
    game_manager = obj

func move():
    # the horror will move after "resolving", and before "deciding"
    # it should allow an extra turn in case you have a hail mary ability
    # if the horror comes too close, it's game over
    # the sprite changes based on their state (following you, looking for you, etc)
    # if you grab the key/keys before it reaches you, you win
    # it should increase its move range as turns pass
    pass
