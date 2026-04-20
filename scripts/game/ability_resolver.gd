extends Node

class_name AbilityResolver

const registry_key = "ability_resolver"

func _ready():
    World.register(registry_key, self)

func use_ability(script: Script):
    var ability = Node.new()
    ability.set_script(script)
    add_child(ability)
