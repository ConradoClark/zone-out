extends Node

class_name HoverTooltip

@export_multiline var tooltip: String
@export var control: Control
var tooltip_handler: UILogText
var tooltip_disabled: bool

func _ready():
    control.mouse_entered.connect(_mouse_entered)
    control.mouse_exited.connect(_mouse_exited)
    World.require(UILogText.registry_key, World.populate(self, "tooltip_handler"))

func _mouse_entered():
    if tooltip_disabled: return
    await World.wait_for_object(UILogText.registry_key)
    tooltip_handler.show_tooltip(str(get_instance_id()), tooltip)

func _mouse_exited():
    await World.wait_for_object(UILogText.registry_key)
    tooltip_handler.hide_tooltip(str(get_instance_id()))
