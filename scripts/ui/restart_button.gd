extends Button

class_name RestartButton
const GAME_LAYER = "uid://c772yqti655jr"

func _ready():
    pressed.connect(_restart)
    
func _restart():
    Fx.change_scene(GAME_LAYER)
