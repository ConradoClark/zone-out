extends Node

class_name SpringExecutor

@export var target: Node
@export var effectors: Array[Effector]
@export var spring: DampedSpring

func _ready():
    var copy: Array[Effector]
    for e in effectors:
        copy.append(e.duplicate())
    effectors.clear()
    for e in copy:
        e.target = target
        effectors.append(e) 

func _process(_delta: float) -> void:
    for e in effectors:
        e.run(spring.target_params.current_pos)
