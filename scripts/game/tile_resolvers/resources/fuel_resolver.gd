extends Resolver

class_name FuelResolver

var resources: ResourceManager
var _required: Array[String] = [ResourceManager.registry_key]

func _ready():
    World.require(ResourceManager.registry_key, World.populate(self, "resources"))

func resolve():
    await World.wait_for_objects(_required)
    # dice roll + others factors to see how much to add
    resources.add_resource("fuel", 1)
    queue_free()
