extends Node

class_name UIResourceCounter

@export var label: Label
@export var resource_name: String

var resource_manager: ResourceManager

func _ready():
    World.require(ResourceManager.registry_key, _on_resource_manager)
    
func _on_resource_manager(obj: ResourceManager):
    resource_manager = obj
    resource_manager.resource_added.connect(_added)
    resource_manager.resource_subtracted.connect(_subtracted)
    _adjust_text(resource_manager.get_amount(resource_name), resource_manager.get_max(resource_name))

func _added(res: String, amount: int, total: int):
    _adjust_text(total, resource_manager.get_max(res))
    pass

func _subtracted(res: String, amount: int, total: int):
    _adjust_text(total, resource_manager.get_max(res))
    pass
    
func _adjust_text(current:int, max:int):
    if max == 999:
        label.text = str(current)
    else:
        label.text = "%s / %s" % [current, max]
