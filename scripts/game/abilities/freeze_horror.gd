extends Node

class_name FreezeHorror

var game_manager: GameManager
var horror: Horror
var effect_layer: CanvasLayer
const FREEZE_EFFECT = preload("uid://cysmd3herxy4u")
const _dependencies: Array[String] = [GameManager.registry_key, Horror.registry_key]

func _ready():
    World.require(GameManager.registry_key, World.populate(self, "game_manager"))
    World.require(Horror.registry_key, World.populate(self, "horror"))
    World.require("effect_layer", World.populate(self, "effect_layer"))
    freeze.call_deferred()
    
func freeze():
    await World.wait_for_objects(_dependencies)
    await _freeze_anim()
    horror.freeze_horror()

func _freeze_anim():
    var effect = FREEZE_EFFECT.instantiate()
    effect_layer.add_child(effect)
    await get_tree().create_timer(1.).timeout
