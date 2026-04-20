extends Node

class_name WfcGenerator

@export var all_tiles: WfcTileCollection
@export var pos_rules: Dictionary[Vector2i, WfcRule]
@export var rules: Dictionary[WfcTile, WfcRule]
@export var grid_size: Vector2i
@export var starting_pos: Vector2i = Vector2i.ZERO
var map: Dictionary[Vector2i, WfcTile] = {}
var possible_tiles: Dictionary[Vector2i, WfcTileCollection] = {}

var started: bool = false
var finished: bool = false
var step: int = 0
var current_pos: Vector2i
var queued_positions: Array[Vector2i]
@export var seed_by_pos: bool
@export var initial_seed_by_pos: int
@export var x_pow: int = 1
@export var y_pow: int = 4

func _ready():
    pass

func collapse():
    while(next_step()):
        pass
    
func _fill_tiles():
    for x in grid_size.x:
        for y in grid_size.y:
            possible_tiles[Vector2i(x,y)+starting_pos] = all_tiles

func _add_neighboring_positions():
    var pos: Vector2i
    if current_pos.x < starting_pos.x + grid_size.x-1:
        pos = current_pos + Vector2i.RIGHT
        if not map.has(pos): queued_positions.append(pos)
    if current_pos.x > starting_pos.x:
        pos = current_pos + Vector2i.LEFT
        if not map.has(pos): queued_positions.append(pos)
    if current_pos.y > starting_pos.y :
        pos = current_pos + Vector2i.UP
        if not map.has(pos): queued_positions.append(pos)
    if current_pos.y < starting_pos.y + grid_size.y-1:
        pos = current_pos + Vector2i.DOWN
        if not map.has(pos): queued_positions.append(pos)
        
func _randomize() -> WfcTile:
    if seed_by_pos:
        var rng_seed =  pow(current_pos.x* initial_seed_by_pos, x_pow) + pow(current_pos.y, y_pow) - initial_seed_by_pos
        return Rng.pick_wfc_seeded(possible_tiles[current_pos].tiles, rng_seed)
    else:
        return Rng.pick_wfc(possible_tiles[current_pos].tiles)
        
func next_step() -> bool:
    if finished: return false
    if not started:
        started = true
        current_pos = starting_pos
        _fill_tiles()
    step+=1
    if not map.has(current_pos):
        if pos_rules.has(current_pos):
            pos_rules[current_pos].apply_rules(current_pos, map, possible_tiles)
        var tile = _randomize()
        if Fx.debug: print_rich("Generated [color=green]%s[/color] at [color=yellow]%s[/color]" % [tile.tile_name, current_pos])
        map[current_pos] = tile
        if rules.has(tile):
            rules[tile].apply_rules(current_pos, map, possible_tiles)
        _add_neighboring_positions()
    if len(queued_positions) > 0:
        current_pos = queued_positions.pop_front()
        return true
    finished = true
    return false
