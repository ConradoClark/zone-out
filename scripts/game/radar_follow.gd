extends Control

class_name RadarFollow

var grid_pos: Vector2i
@onready var texture_rect: Sprite2D = $TextureRect
@onready var pointer_rotation: TextureRect = $Control/PointerRotation
@onready var label: Label = $Label
var cooldown: int = -1

var game_manager: GameManager
var astronaut: Astronaut
var blink: Timer

func _ready():
    World.require(GameManager.registry_key, _on_game_manager)
    World.require(Astronaut.registry_key, World.populate(self, "astronaut"))
    blink = Timer.new()
    blink.wait_time = .25
    blink.timeout.connect(_blink)
    add_child(blink)

func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_move_committed.connect(_on_move_committed)
    
func _on_move_committed(_pos: Vector2i):
    _update_marker()
    if cooldown > 0:
        cooldown-=1
    if cooldown == 1:
        blink.start()
    if cooldown == 0:
        queue_free()
        
func _blink():
    visible = !visible
   
func _update_marker():
    var astronaut_pos = Vector2(astronaut.grid_position)
    var curio_pos = Vector2(grid_pos)
    const center = Vector2(960,540-122)
    const radius = 300
    var distance = astronaut_pos - curio_pos
    var rot = astronaut_pos.angle_to_point(curio_pos) 
    pointer_rotation.rotation = rot + PI*.5
    global_position = center + Vector2(cos(rot), sin(rot)) * radius
    var obj_scale = lerp(2., 0.75, clamp(distance.length()*.1, 0., 1.))
    scale = Vector2(obj_scale,obj_scale)
    
func set_data(pos: Vector2i, display_name: String, texture: Texture2D):
    grid_pos = pos
    label.text = display_name
    texture_rect.texture = texture
    _update_marker()
