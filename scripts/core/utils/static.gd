extends Node

signal on_tick

var global_timer: Timer
var timer_i: int = 0
var debug = false

func _ready():
    global_timer = Timer.new()
    global_timer.autostart = true
    global_timer.wait_time = 0.25
    add_child(global_timer)
    global_timer.timeout.connect(_on_tick)
    
func _on_tick():
    timer_i = (timer_i + 1) % 2
    on_tick.emit(timer_i == 1)

func call_delayed(seconds: float, fn: Callable):
    await get_tree().create_timer(seconds, false).timeout
    fn.call()

func change_scene(scene: String):
  var instance = load(scene).instantiate()
  World.unregister_all()
  get_tree().root.add_child(instance)
  await get_tree().process_frame
  var old_scene = get_tree().current_scene
  get_tree().current_scene = instance
  old_scene.free()
