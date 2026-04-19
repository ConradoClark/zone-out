extends Actor

class_name Astronaut

const registry_key = "astronaut"

var grid_position: Vector2i
var game_manager: GameManager
var tile_renderer: TileRenderer
var resource_manager: ResourceManager

var move_tween: Tween
var move_cost:int = 1

func _ready():
    World.register(registry_key, self)
    World.require(GameManager.registry_key, _on_game_manager)
    World.require(TileRenderer.registry_key, World.populate(self, "tile_renderer"))
    World.require(ResourceManager.registry_key, World.populate(self, "resource_manager"))
    _print_position()
    
func _print_position():
    if not Fx.debug: return
    print_rich("[color=blue]Astronaut[/color] is at[color=yellow] %s" % grid_position)
    
func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_move_intention.connect(_on_move)
    game_manager.on_resolve.connect(_on_resolve)
    
func _on_move(target: Vector2i):
    var target_pos = tile_renderer.map_2_world(target)
    grid_position = target
    resource_manager.subtract_resource("fuel", move_cost)
    move_anim.call_deferred(target_pos)
    
func _on_resolve():
    var has_fuel = resource_manager.get_amount("fuel") > 0
    game_manager.fuel_checked(has_fuel)

func move_anim(target: Vector2):
    if move_tween:
        move_tween.kill()
    move_tween = create_tween()
    move_tween.tween_property(self, "global_position", target, .5)\
        .set_ease(Tween.EASE_OUT)\
        .set_trans(Tween.TRANS_SPRING)
    await move_tween.finished
    game_manager.commit_move(target)
    _print_position()
