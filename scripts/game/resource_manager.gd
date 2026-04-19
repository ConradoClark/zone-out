extends Node

class_name ResourceManager

@export var resources: Dictionary[String, int]
@export var resources_max: Dictionary[String, int]

const registry_key: String = "resource_manaager"
signal resource_added(res: String, amount: int, total: int)
signal resource_subtracted(res: String, amount: int, total: int)

func _ready():
    World.register(registry_key, self)

func add_resource(res: String, amount: int):
    if not resources.has(res):
        resources[res] = amount
        resource_added.emit(res, amount, amount)
        return
    var max_res = 999
    if resources_max.has(res):
        max_res = resources_max[res]
    resources[res] = clamp(resources[res]+amount, 0, max_res)
    resource_added.emit(res, amount, resources[res])

func subtract_resource(res: String, amount: int):
    if not resources.has(res):
        return
    resources[res] = clamp(resources[res]-amount, 0 , resources[res])
    resource_subtracted.emit(res, amount, resources[res])
