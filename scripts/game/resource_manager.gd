extends Node

class_name ResourceManager

@export var resources: Dictionary[String, int]
@export var resources_max: Dictionary[String, int]

const registry_key: String = "resource_manaager"
signal resource_added(res: String, amount: int, total: int)
signal resource_subtracted(res: String, amount: int, total: int)
signal resources_changed
var low_fuel: Control

func _ready():
    World.register(registry_key, self)
    World.require("low_fuel", World.populate(self, "low_fuel"))

func add_resource(res: String, amount: int):
    if not resources.has(res):
        resources[res] = amount
        resource_added.emit(res, amount, amount)
        resources_changed.emit()
        return
    var max_res = get_max(res)
    resources[res] = clamp(resources[res]+amount, 0, max_res)
    resource_added.emit(res, amount, resources[res])
    if res == "fuel" and resources[res] >= 5 and low_fuel != null:
        low_fuel.visible = false
    resources_changed.emit()

func subtract_resource(res: String, amount: int):
    if not resources.has(res):
        return
    resources[res] = clamp(resources[res]-amount, 0 , resources[res])
    if res == "fuel" and resources[res] < 5 and low_fuel != null:
        low_fuel.visible = true
    resource_subtracted.emit(res, amount, resources[res])
    resources_changed.emit()
    
func can_pay(cost: Dictionary[String, int]) -> bool:
    for item in cost:
        if not resources.has(item) or resources[item] < cost[item]:
            return false
    return true 
    
func pay_resources(cost: Dictionary[String, int]) -> bool:
    for item in cost:
        if not resources.has(item) or resources[item] < cost[item]:
            return false
    for item in cost:
        subtract_resource(item, cost[item])
    return true
    
func get_amount(res:String) -> int:
    if not resources.has(res):
        return 0
    return resources[res]
    
func get_max(res: String):
    if resources_max.has(res):
        return resources_max[res]
    return 999
