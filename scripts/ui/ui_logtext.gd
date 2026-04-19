extends Node

class_name UILogText

@export var log_caption: Label
@export var log_label: TypewriterLabel
var blocker: Blocker
var dict: Dictionary[String, String] = {}
var last_tooltip: String
var last_log: String
var is_log: bool
const registry_key = "ui_log"

func _ready():
    World.register(registry_key, self)
    blocker = Blocker.new()
    add_child(blocker)
    last_log = log_label.target_text
    is_log = true
    
func show_log(content: String):
    last_log = content
    _update_tooltip()

func show_tooltip(key: String, content: String):
    blocker.block(key)
    dict[key] = content
    last_tooltip = content
    _update_tooltip()

func hide_tooltip(key: String):
    blocker.unblock(key)
    dict.erase(key)
    _update_tooltip()

func _update_tooltip():
    if blocker.is_blocked() and is_log:
        is_log = false
        log_caption.text = "Tooltip"
        log_label.show_text(last_tooltip)
    elif not blocker.is_blocked():
        if not is_log:
            is_log = true
            log_caption.text = "Log"
        log_label.show_text(last_log)
