extends PropertyEffector

class_name VisibilityAlphaEffector

@export var alpha_on_zero: float
@export var alpha_on_one: float

func _init() -> void:
    property_name = "modulate:a"

func run(value: float):
    value_on_zero = alpha_on_zero
    value_on_one = alpha_on_one
    super(value)
