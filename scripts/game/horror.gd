extends Node

class_name Horror

@export var grid_pos: Vector2i
@export var icon_control: Control
@export var pointer: Control
@export var description_label: Label

var game_manager: GameManager
var astronaut: Astronaut
var tile_renderer: TileRenderer
var horror_light: Node2D
var horror_state: State
var default_speed: int = 1
var looking_factor: int = 10
var detected_factor: int = 10
var freezing_factor: int = 0
const registry_key = "horror"

enum State{
    LookingForYou,
    ChasingYou,
    ClosingIn,
    ImminentAttack,
    FreezingLight
}

func _ready():
    World.register(registry_key, self)
    World.require(GameManager.registry_key, _on_game_manager)
    World.require(Astronaut.registry_key, World.populate(self, "astronaut"))
    World.require("horror_light", World.populate(self, "horror_light"))
    World.require("tile_renderer", World.populate(self, "tile_renderer"))
    _update_marker()
    
func _print_position():
    if not Fx.debug: return
    print_rich("[color=red]Horror[/color] is at[color=yellow] %s" % grid_pos)
    
func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_state_changed.connect(_on_state_changed)

func _on_state_changed(state: GameManager.State):
    if state == GameManager.State.MovingHorror:
        move()

func move():
    # the horror will move after "resolving", and before "deciding"
    # it should allow an extra turn in case you have a hail mary ability
    # if the horror comes too close, it's game over
    # the sprite changes based on their state (following you, looking for you, etc)
    # if you grab the key/keys before it reaches you, you win
    # it should increase its move range as turns pass
    match horror_state:
        State.LookingForYou: _looking_for_you()
        State.ChasingYou: _chasing_you()
        State.ClosingIn: _looking_for_you()
        State.ImminentAttack: _chasing_you()
    var distance = (grid_pos - astronaut.grid_position).length()
    if horror_state == State.FreezingLight:
        freezing_factor-=1
        if freezing_factor == 0:
            horror_state = State.LookingForYou
    if distance > 8 and horror_state == State.ChasingYou:
        detected_factor -= randi_range(1,2)
        if detected_factor <=0:
            horror_state = State.LookingForYou
    if distance < 6 and [State.ChasingYou, State.LookingForYou].has(horror_state):
        horror_state = State.ClosingIn
    if distance <= 2.9 and [State.ChasingYou, State.LookingForYou, State.ClosingIn].has(horror_state):
        horror_state = State.ImminentAttack
    if distance > 6 and horror_state == State.ClosingIn:
        horror_state = State.LookingForYou
    _update_marker()
    if distance <= 2:
        game_manager.lose("The Cosmic Horror got you!")
        return
    await get_tree().process_frame
    game_manager.resolve_horror()
    pass
    
func _looking_for_you():
    # should either walk in your direction, or a perpendicular direction, never to the opposite
    # has a chance (after n turns) to figure out your position
    # 50% chance to walk in your direction
    var chase = randi_range(0, 1)
    var dirs = _calc_directions()
    if chase == 1:
        var possible: Array[Vector2i] = []
        for dir in dirs:
            var result = dirs[dir]
            if result > 0: possible.append(dir)
        if len(possible)>0:
            var chosen = randi_range(0, len(possible)-1)
            grid_pos += possible[chosen]
    else:
        var possible: Array[Vector2i] = []
        var alternative: Array[Vector2i] = []
        for dir in dirs:
            var result = dirs[dir]
            if result == 0: possible.append(dir)
            if result > 0: alternative.append(dir)
        if len(possible)>0:
            var chosen = randi_range(0, len(possible)-1)
            grid_pos += possible[chosen]
        elif len(alternative)>0:
            var chosen = randi_range(0, len(alternative)-1)
            grid_pos += alternative[chosen]
    pass

func _calc_directions() -> Dictionary[Vector2i, int]:
    var calcs: Dictionary[Vector2i, int] = {}
    var astronaut_pos = Vector2(astronaut.grid_position)
    var horror_pos = Vector2(grid_pos)
    var distance = astronaut_pos - horror_pos
    var direction = distance.normalized()
    if sign(direction.x) > 0.25:
        calcs[Vector2i.RIGHT] = 1
        calcs[Vector2i.LEFT] = -1
    elif sign(direction.x) < -0.25:
        calcs[Vector2i.RIGHT] = -1
        calcs[Vector2i.LEFT] = 1
    else:
        calcs[Vector2i.LEFT] = 0
        calcs[Vector2i.RIGHT] = 0
    if sign(direction.y) > 0.25:
        calcs[Vector2i.UP] = -1
        calcs[Vector2i.DOWN] = 1
    elif sign(direction.y) < -0.25:
        calcs[Vector2i.UP] = 1
        calcs[Vector2i.DOWN] = -1
    else:
        calcs[Vector2i.LEFT] = 0
        calcs[Vector2i.RIGHT] = 0
    return calcs  
    
func _chasing_you():
    #moves twice in your direction
    var dirs = _calc_directions()
    for i in 2:
        var possible: Array[Vector2i] = []
        for dir in dirs:
            var result = dirs[dir]
            if result > 0: possible.append(dir)
        if len(possible)>0:
            var chosen = randi_range(0, len(possible)-1)
            grid_pos += possible[chosen]
    
func _update_marker():
    _print_position()
    var astronaut_pos = Vector2(astronaut.grid_position)
    var horror_pos = Vector2(grid_pos)
    horror_light.global_position = tile_renderer.map_2_world(grid_pos)
    const center = Vector2(960,540-122)
    const radius = 300
    var distance = astronaut_pos - horror_pos
    var rotation = astronaut_pos.angle_to_point(horror_pos) 
    pointer.rotation = rotation + PI*.5
    icon_control.global_position = center + Vector2(cos(rotation), sin(rotation)) * radius
    var scale = lerp(2., 0.75, clamp(distance.length()*.1, 0., 1.))
    icon_control.scale = Vector2(scale,scale)
    match horror_state:
        State.LookingForYou: description_label.text = "Looking for You"
        State.ChasingYou: description_label.text = "Chasing You"
        State.ClosingIn: description_label.text = "Closing In..."
        State.ImminentAttack: description_label.text = "You'll soon be mine"
        State.FreezingLight: description_label.text = "It stopped on its tracks"
    
func freeze_horror():
    freezing_factor = 3
    horror_state = State.FreezingLight
    _update_marker()
    
func detect_astronaut():
    detected_factor = 4
    horror_state = State.ChasingYou
    _update_marker()
