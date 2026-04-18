extends WfcRule

class_name WfcRuleAdjacencyWhitelist

@export var rules: Dictionary[Vector2i, WfcTileCollection]

func apply_rules(pos: Vector2i, _map: Dictionary[Vector2i, WfcTile], possible_tiles: Dictionary[Vector2i, WfcTileCollection]):
    for key in rules:
        if not possible_tiles.has(pos+key):
            possible_tiles[pos + key] = rules[key]
            continue
        var current = WfcTileCollection.new()
        for item in possible_tiles[pos + key]:
            if rules[key].tiles.has(item):
                current.tiles.append(item)
        possible_tiles[pos + key] = current
