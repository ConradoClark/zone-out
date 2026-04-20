extends Resolver

class_name EnergyResolver

var resources: ResourceManager
var _required: Array[String] = [ResourceManager.registry_key]

func _ready():
    World.require(ResourceManager.registry_key, World.populate(self, "resources"))

func resolve():
    await World.wait_for_objects(_required)
    # dice roll + others factors to see how much to add
    resources.add_resource("energy", randi_range(2, 4))
    queue_free()
