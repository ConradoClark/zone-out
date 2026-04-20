extends Node

class_name KillAfter

@export var duration: float
@export var reference: Node
var timer: Timer

func _ready():
    timer = Timer.new()
    timer.autostart = true
    timer.wait_time = duration
    timer.one_shot = true
    timer.timeout.connect(_on_kill)
    
func _on_kill():
    reference.queue_free()
