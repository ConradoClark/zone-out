extends Node

class_name Horror

@export var grid_pos: Vector2i
@export var icon_control: Control
@export var pointer: Control
@export var description_label: Label
var game_manager: GameManager
var astronaut: Astronaut
var horror_state: State
var default_speed: int = 1
var looking_factor: int = 10
var detected_factor: int = 10

enum State{
    LookingForYou,
    ChasingYou,
    ClosingIn,
    ImminentAttack
}

func _ready():
    World.require(GameManager.registry_key, _on_game_manager)
    World.require(Astronaut.registry_key, World.populate(self, "astronaut"))
    _print_position()
    
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
            _update_marker() 
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
            _update_marker() 
        elif len(alternative)>0:
            var chosen = randi_range(0, len(alternative)-1)
            grid_pos += alternative[chosen]
            _update_marker()
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
    pass
    # should always walk in your direction, with a higher speed
    # 
    
func _update_marker():
    _print_position()
    var astronaut_pos = Vector2(astronaut.grid_position)
    var horror_pos = Vector2(grid_pos)
    var distance = astronaut_pos - horror_pos
    pass
