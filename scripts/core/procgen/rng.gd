extends Node

class_name Rng

static var rng = RandomNumberGenerator.new()

static func pick(entries: Dictionary[Variant, float]) -> Variant:
    var sum_of_weights = 0.0
    for weight in entries.values():
        sum_of_weights += weight
    var normalized_weights = []
    var accumulated_weight = 0.0
    for weight in entries.values():
        accumulated_weight += weight / sum_of_weights
        normalized_weights.append(accumulated_weight)
    var result = randf()
    var keys = entries.keys()
    for i in range(normalized_weights.size()):
        if result <= normalized_weights[i]:
            return keys[i]
    return null
    
static func pick_wfc_seeded(entries: Array[WfcTile], rng_seed: int) -> WfcTile:
    var sum_of_weights = 0.0
    for entry in entries:
        sum_of_weights += entry.weight
    var normalized_weights = []
    var accumulated_weight = 0.0
    for entry in entries:
        accumulated_weight += entry.weight / sum_of_weights
        normalized_weights.append(accumulated_weight)
    rng.seed = rng_seed
    var result = rng.randf()
    for i in range(normalized_weights.size()):
        if result <= normalized_weights[i]:
            return entries[i]
    return null

static func pick_wfc(entries: Array[WfcTile]) -> WfcTile:
    var sum_of_weights = 0.0
    for entry in entries:
        sum_of_weights += entry.weight
    var normalized_weights = []
    var accumulated_weight = 0.0
    for entry in entries:
        accumulated_weight += entry.weight / sum_of_weights
        normalized_weights.append(accumulated_weight)
    var result = randf()
    for i in range(normalized_weights.size()):
        if result <= normalized_weights[i]:
            return entries[i]
    return null
