extends PropertyEffector

class_name UniformScaleEffector

@export var scale_on_zero: float
@export var scale_on_one: float

func _init() -> void:
    property_name = "scale"

func run(value: float):
    value_on_zero = Vector2(scale_on_zero, scale_on_zero)
    value_on_one = Vector2(scale_on_one, scale_on_one)
    super(value)
