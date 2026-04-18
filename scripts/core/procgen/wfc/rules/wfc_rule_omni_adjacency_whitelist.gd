extends WfcRule

class_name WfcRuleOmniAdjacencyWhitelist

@export var tile_collection: WfcTileCollection

func apply_rules(pos: Vector2i, _map: Dictionary[Vector2i, WfcTile], possible_tiles: Dictionary[Vector2i, WfcTileCollection]):
    for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]:
        if not possible_tiles.has(pos+direction):
            possible_tiles[pos + direction] = tile_collection
            continue
        var current = WfcTileCollection.new()
        for item in possible_tiles[pos + direction].tiles:
            if tile_collection.tiles.has(item):
                current.tiles.append(item)
        possible_tiles[pos + direction] = current
