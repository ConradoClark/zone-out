extends Control

class_name HighlighterWidget

@onready var highlighted: TextureRect = %Highlighted
@onready var selected: TextureRect = %Selected
@onready var fade_out_chosen: TweenExecutor = %FadeOut_Chosen
@onready var fade_out_not_chosen: TweenExecutor = %FadeOut_NotChosen

var finished: bool = false
var is_selected: bool = false
var on_highlight_fn: Callable

func _ready():
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)

func _input(event: InputEvent) -> void:
    if finished: return
    if event.is_action("click") and is_selected:
        on_highlight_fn.call()
    
func _on_mouse_entered():
    if finished: return
    set_selected(true)
    
func _on_mouse_exited():
    if finished: return
    set_selected(false)

func set_selected(state: bool):
    is_selected = state
    highlighted.visible = not is_selected
    selected.visible = is_selected
    
func fade_out(chosen: bool):
    finished = true
    if chosen:
        fade_out_chosen.run(1.)
    else:
        fade_out_not_chosen.run(1.)
