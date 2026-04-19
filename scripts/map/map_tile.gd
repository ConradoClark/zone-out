extends Node2D

class_name MapTile

var map_pos: Vector2i
var ref_tile: WfcTile
@onready var sprite: Sprite2D = $Texture

var rotation_tween: Tween
var rotating: bool

func _ready():
    Fx.on_tick.connect(_on_anim_tick)
    keep_rotating.call_deferred()
    
func keep_rotating():
    var dir = 1. if randf() < 0.5 else -1.
    rotating = true
    while rotating:
        if rotation_tween: 
            rotation_tween.kill()
        rotation_tween = create_tween()
        rotation_tween.tween_property(sprite, "rotation_degrees", 360 * dir, randf_range(36, 72.)) 
        await rotation_tween.finished
        sprite.rotation_degrees = 0.

func set_tile(tile: WfcTile, pos: Vector2i):
    ref_tile = tile
    map_pos = pos

func _on_anim_tick(odd: bool):
    sprite.frame = 1 if odd else 0
