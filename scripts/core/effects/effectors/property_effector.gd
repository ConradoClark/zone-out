extends Effector

class_name PropertyEffector

var property_name: String
var value_on_zero: Variant
var value_on_one: Variant

func run(interpolation: float):
    var value = lerp(value_on_zero, value_on_one, interpolation)
    target.set_indexed(property_name, value)
