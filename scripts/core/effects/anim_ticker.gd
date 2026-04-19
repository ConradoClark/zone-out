extends Node

class_name AnimTicker

@export var sprite: Sprite2D

func _ready():
    Fx.on_tick.connect(_on_anim_tick)

func _on_anim_tick(odd: bool):
    sprite.frame = 1 if odd else 0
