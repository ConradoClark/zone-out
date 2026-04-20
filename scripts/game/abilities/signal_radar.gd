extends Node

class_name SignalRadar

var game_manager: GameManager
var horror: Horror
var ui_layer: CanvasLayer
var effect_layer: CanvasLayer
const RADAR_EFFECT = preload("uid://bmr6g786bsc3s")
const INTEREST_ICON = preload("uid://bjubl51v1pe8q")
const _dependencies: Array[String] = [GameManager.registry_key, Horror.registry_key, "ui_layer"]
const KEY_FOLLOWING = preload("uid://v4yyimymsove")

func _ready():
    World.require(GameManager.registry_key, World.populate(self, "game_manager"))
    World.require(Horror.registry_key, World.populate(self, "horror"))
    World.require("ui_layer", World.populate(self, "ui_layer"))
    World.require("effect_layer", World.populate(self, "effect_layer"))
    use_radar.call_deferred()
    
func use_radar():
    await World.wait_for_objects(_dependencies)
    await _radar_anim()
    horror.detect_astronaut()
    for i in game_manager.keys_positions:
        var interest_icon = INTEREST_ICON.instantiate() as RadarFollow
        interest_icon.cooldown = 4
        ui_layer.add_child(interest_icon)
        interest_icon.set_data(i, "Cosmic Key", KEY_FOLLOWING)

func _radar_anim():
    var effect = RADAR_EFFECT.instantiate()
    effect_layer.add_child(effect)
    await get_tree().create_timer(1.).timeout
