extends PropertyEffector

class_name GlobalPositionEffector

@export var position_on_zero: Vector2
@export var position_on_one: Vector2

func _init() -> void:
    property_name = "global_position"

func run(value: float):
    value_on_zero = position_on_zero
    value_on_one = position_on_one
    super(value)
