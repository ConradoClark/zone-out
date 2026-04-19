extends Node

class_name CameraOnResolve

var game_manager: GameManager
var main_camera: Camera2D
var initial_position: Vector2
var astronaut: Astronaut

var move_tween: Tween

func _ready():
    World.require(GameManager.registry_key, _on_game_manager)
    World.require("main_camera", _on_main_camera)
    World.require(Astronaut.registry_key, World.populate(self, "astronaut"))
    
func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_resolve.connect(_on_resolve)

func _on_main_camera(obj: Camera2D):
    main_camera = obj
    initial_position = main_camera.global_position
    
func _on_resolve():
    if move_tween:
        move_tween.kill()
    move_tween = create_tween()
    move_tween.tween_property(main_camera, "global_position", initial_position + astronaut.global_position, 1.)\
        .set_ease(Tween.EASE_OUT)\
        .set_trans(Tween.TRANS_BACK)
    await move_tween.finished
    game_manager.camera_resolve()
    
