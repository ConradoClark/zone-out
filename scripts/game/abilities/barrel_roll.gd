extends Node

class_name BarrelRoll

var move_highlighter: UIMoveHighlighter

func _ready():
    World.require("move_highlighter", World.populate(self, "move_highlighter"))
    _barrel_roll.call_deferred()

func _barrel_roll():
    await World.wait_for_object("move_highlighter")
    move_highlighter._enable_barrel_roll()
    
