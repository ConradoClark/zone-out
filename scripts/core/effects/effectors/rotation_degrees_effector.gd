extends PropertyEffector

class_name RotationDegreesEffector

@export var rotation_on_zero: float
@export var rotation_on_one: float

func _init() -> void:
    property_name = "rotation_degrees"

func run(value: float):
    value_on_zero = rotation_on_zero
    value_on_one = rotation_on_one
    super(value)
