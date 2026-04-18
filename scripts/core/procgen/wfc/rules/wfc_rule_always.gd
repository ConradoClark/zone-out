extends WfcRule

class_name WfcRuleAlways

@export var collection: WfcTileCollection

func apply_rules(pos: Vector2i, _map: Dictionary[Vector2i, WfcTile], possible_tiles: Dictionary[Vector2i, WfcTileCollection]):
    var new_tiles = WfcTileCollection.new()
    for item in collection.tiles:
        new_tiles.tiles.append(item)
    possible_tiles[pos] = new_tiles
