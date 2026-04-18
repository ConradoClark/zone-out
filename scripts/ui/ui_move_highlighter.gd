extends Control

class_name UIMoveHighlighter

const MOVE_HIGHLIGHTER = preload("uid://ba582i1ba3kq8")
const highlighter_half_size = Vector2(64,32)

var game_manager: GameManager
var main_camera: Camera2D
var tile_renderer: TileRenderer
var astronaut: Astronaut

var _dependencies: Array[String] = [GameManager.registry_key, TileRenderer.registry_key,\
    "main_camera", Astronaut.registry_key]
var _dependencies_loaded: bool = false

var highlighters: Array[HighlighterWidget] = []

func _ready():
    World.require(GameManager.registry_key, _on_game_manager)
    World.require("main_camera", World.populate(self, "main_camera"))
    World.require(TileRenderer.registry_key, World.populate(self, "tile_renderer"))
    World.require(Astronaut.registry_key, World.populate(self, "astronaut"))
    
func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_state_changed.connect(_on_game_state)
    
func _on_game_state(state: GameManager.State):
    if state != GameManager.State.Deciding:
        #hide highlighting
        return
    calculate_highlighters()

func calculate_highlighters():
    if not _dependencies_loaded:
        await World.wait_for_objects(_dependencies)
        _dependencies_loaded = true
    highlighters.clear()
    for c in get_children():
        c.queue_free()
    var moves = _calculate_possible_movement()
    for m in moves:
        _spawn_highlighter(m)
        
func _spawn_highlighter(pos: Vector2i):
    var target_grid_pos = astronaut.grid_position + pos
    var highlight = MOVE_HIGHLIGHTER.instantiate() as HighlighterWidget
    var world_pos = tile_renderer.map_2_world(target_grid_pos) - highlighter_half_size
    var screen_pos = main_camera.get_canvas_transform() * world_pos
    highlight.global_position = screen_pos
    highlight.on_highlight_fn = func(): _move_intention(highlight, target_grid_pos)
    add_child(highlight)
    highlighters.append(highlight)

func _move_intention(obj: HighlighterWidget, pos: Vector2i):
    for widget in highlighters:
        widget.fade_out(widget == obj)
    game_manager.process_move_intention(pos)
    
func _calculate_possible_movement() -> Array[Vector2i]:
    return [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
