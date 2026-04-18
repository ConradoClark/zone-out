extends Node

class_name TweenExecutor

@export var run_at_start: bool
@export var initial_target: float = 1.
@export var initial_value: float
@export var target: Node
@export var effectors: Array[Effector]
@export var duration: float
@export var easing: Tween.EaseType
@export var transition: Tween.TransitionType
@export var delay: float
@export var loop: bool
@export var ping_pong: bool
var current_interpolation: float
var tween: Tween

func _ready():
    var copy: Array[Effector]
    for e in effectors:
        copy.append(e.duplicate())
    effectors.clear()
    for e in copy:
        e.target = target
        effectors.append(e) 
    jump_to_value(initial_value)
    if run_at_start:
        if loop:
            run_and_keep_running.call_deferred()
        else: 
            run(initial_target)
            
func run_and_keep_running():
    var next_target = initial_target
    while(loop):
        await run(next_target)
        await get_tree().process_frame
        next_target = 1 - next_target
        
func jump_to_value(target_value: float):
    current_interpolation = target_value
    for e in effectors:
        e.run(current_interpolation)

func run(target_value: float):
    var multiplier = abs(target_value - current_interpolation)
    var dur = duration * multiplier
    if tween:
        tween.kill()
    tween = create_tween()
    tween.set_parallel(true)
    for e in effectors:
        tween.tween_method(e.run, current_interpolation, target_value, dur)\
            .set_ease(easing)\
            .set_trans(transition)\
            .set_delay(delay)
    await tween.finished
    if ping_pong: current_interpolation = target_value
    
func run_in():
    await run(1.)

func run_out():
    await run(0.)
