extends Actor

class_name Astronaut

const registry_key = "astronaut"

var grid_position: Vector2i
var game_manager: GameManager
var tile_renderer: TileRenderer

var move_tween: Tween

func _ready():
    World.register(registry_key, self)
    World.require(GameManager.registry_key, _on_game_manager)
    World.require(TileRenderer.registry_key, World.populate(self, "tile_renderer"))
    
func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_move_intention.connect(_on_move)
    
func _on_move(target: Vector2i):
    var target_pos = tile_renderer.map_2_world(target)
    grid_position = target
    move_anim.call_deferred(target_pos)

func move_anim(target: Vector2):
    if move_tween:
        move_tween.kill()
    move_tween = create_tween()
    move_tween.tween_property(self, "global_position", target, .5)\
        .set_ease(Tween.EASE_OUT)\
        .set_trans(Tween.TRANS_SPRING)
    await move_tween.finished
    game_manager.commit_move(target)
