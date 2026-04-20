extends Node

class_name TileResolver

var game_manager: GameManager
var tile_renderer:  TileRenderer

func _ready():
    World.require(GameManager.registry_key, _on_game_manager)
    World.require(TileRenderer.registry_key, World.populate(self, "tile_renderer"))
    
func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_move_committed.connect(_on_commit)
    
func _on_commit(pos: Vector2):
    await World.wait_for_object(TileRenderer.registry_key)
    var map_pos = tile_renderer.world_2_map(pos)
    var tile = tile_renderer.current_generator.map[map_pos] as WfcTile
    if tile.resolver:
        var resolver = Node.new()
        resolver.set_script(tile.resolver)
        add_child(resolver)
        await resolver.call("resolve")
    tile_renderer.erase_tile(map_pos)
    game_manager.resolve()
    
