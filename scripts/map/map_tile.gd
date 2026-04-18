extends Node2D

class_name MapTile

var map_pos: Vector2i
var ref_tile: WfcTile
@onready var sprite: Sprite2D = $Texture

func set_tile(tile: WfcTile, pos: Vector2i):
    ref_tile = tile
    map_pos = pos
