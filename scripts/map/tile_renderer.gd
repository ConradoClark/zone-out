extends Node2D

class_name TileRenderer

@export var debug_generator: WfcGenerator
const tile_size = Vector2(128, 128)
const tile_gap = Vector2(0,0)
const MAP_TILE = preload("uid://c3wbsone14rsk")
const RESOURCE_KEY = preload("uid://d00ojbhe1arih")
const NOTHING = preload("uid://kwl4lksdt8t2")

const registry_key = "tile_renderer"
var current_generator: WfcGenerator
var game_manager: GameManager
var tiles: Dictionary[Vector2i, Node] = {}
var has_rendered: bool

func _ready():
    World.register(registry_key, self)
    World.require(GameManager.registry_key, World.populate(self,"game_manager"))
    _render_all.call_deferred()

func _render_all():
    await World.wait_for_object(GameManager.registry_key)
    current_generator = debug_generator
    for i in game_manager.keys_positions:
        var key_rule = WfcRuleAlways.new()
        key_rule.collection = WfcTileCollection.new()
        var resources: Array[WfcTile] = [RESOURCE_KEY] 
        key_rule.collection.tiles = resources
        current_generator.pos_rules[i] = key_rule
    current_generator.collapse()
    render(current_generator.map)

func render(map: Dictionary[Vector2i, WfcTile]):
    for item in map:
        var tile_type = map[item]
        var tile = MAP_TILE.instantiate() as MapTile
        add_child(tile)
        if DefaultTileTextures.default_textures.textures.has(tile_type):
            tile.sprite.texture = DefaultTileTextures.default_textures.textures[tile_type]
        tile.global_position = global_position + (tile_size + tile_gap)*Vector2(item.x,item.y)
        tiles[item] = tile
    has_rendered = true
        
func erase_tile(pos: Vector2i):
    if tiles.has(pos):
        tiles[pos].queue_free()
        tiles.erase(pos)
    current_generator.map[pos] = NOTHING

func world_2_map(pos: Vector2) -> Vector2i:
    var map_pos = (pos - global_position) / (tile_size + tile_gap)
    return Vector2i(floori(map_pos.x), floori(map_pos.y))

func map_2_world(pos: Vector2i) -> Vector2:
    return global_position + Vector2(pos) * (tile_size + tile_gap)
