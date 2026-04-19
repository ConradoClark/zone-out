extends Node2D

class_name TileRenderer

@export var debug: bool
@export var debug_generator: WfcGenerator
const tile_size = Vector2(128, 128)
const tile_gap = Vector2(0,0)
const MAP_TILE = preload("uid://c3wbsone14rsk")

const registry_key = "tile_renderer"
var current_generator: WfcGenerator

func _ready():
    World.register(registry_key, self)
    if debug:
        current_generator = debug_generator
        debug_generator.collapse()
        render(debug_generator.map)

func render(map: Dictionary[Vector2i, WfcTile]):
    for item in map:
        var tile_type = map[item]
        var tile = MAP_TILE.instantiate() as MapTile
        add_child(tile)
        if TileTextures.default_textures.textures.has(tile_type):
            tile.sprite.texture = TileTextures.default_textures.textures[tile_type]
        tile.global_position = global_position + (tile_size + tile_gap)*Vector2(item.x,item.y)

func world_2_map(pos: Vector2) -> Vector2i:
    var map_pos = (pos - global_position) / (tile_size + tile_gap)
    return Vector2i(floori(map_pos.x), floori(map_pos.y))

func map_2_world(pos: Vector2i) -> Vector2:
    return global_position + Vector2(pos) * (tile_size + tile_gap)
