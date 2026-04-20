extends Resolver

class_name KeyResolver

var resources: ResourceManager
var game_manager: GameManager
var astronaut: Astronaut
var _required: Array[String] = [ResourceManager.registry_key, Astronaut.registry_key]

func _ready():
    World.require(ResourceManager.registry_key, World.populate(self, "resources"))
    World.require(GameManager.registry_key, World.populate(self, "game_manager"))
    World.require(Astronaut.registry_key, World.populate(self, "astronaut"))

func resolve():
    await World.wait_for_objects(_required)
    resources.add_resource("keys", 1)
    if game_manager.keys_positions.has(astronaut.grid_position):
        game_manager.keys_positions.erase(astronaut.grid_position)
        game_manager.fire_keys_changed()
    if resources.get_amount("keys") >= 2:
        game_manager.win()
    queue_free()
