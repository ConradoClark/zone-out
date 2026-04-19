extends Label

class_name TypewriterLabel

@export var speed_seconds: float
var target_text: String
var timer: Timer
var chars:int = 0

func _ready():
    timer = Timer.new()
    timer.wait_time = speed_seconds
    timer.timeout.connect(_timeout)
    add_child(timer)
    show_text(text)

func show_text(content: String):
    if target_text == content: return
    target_text = content
    text = ""
    chars = 0
    timer.start()
    
func _timeout():
    chars+=1
    text = target_text.substr(0, chars)
    if text == target_text:
        timer.stop()
