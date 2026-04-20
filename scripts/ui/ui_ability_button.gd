extends Node

class_name UIAbilityButton

@export var ability_function: Script
@export var control: Control
@export var border: TextureRect
@export var image: TextureRect
@export var cooldown: int
@export var tooltip: HoverTooltip
@export var cost: Dictionary[String, int] = {}
var current_cooldown: int = 0

var resolver: AbilityResolver
var game_manager: GameManager
var resource_manager: ResourceManager
var is_hover: bool
var executed: bool
var tooltip_text: String
var can_pay: bool

func _ready():
    World.require(AbilityResolver.registry_key, _on_ability_resolver)
    World.require(GameManager.registry_key, _on_game_manager)
    World.require(ResourceManager.registry_key, _on_resource_manager)
    control.mouse_entered.connect(_mouse_entered)
    control.mouse_exited.connect(_mouse_exited)
    tooltip_text = tooltip.tooltip
    _recalculate_cost.call_deferred()
    
func _mouse_entered():
    is_hover = true

func _mouse_exited():
    is_hover = false
    
func _on_resource_manager(obj: ResourceManager):
    resource_manager = obj
    resource_manager.resources_changed.connect(_recalculate_cost)
    
func _recalculate_cost():
    can_pay = resource_manager.can_pay(cost)
    _change_state_because_of_cost()
    
func _on_game_manager(obj: GameManager):
    game_manager = obj
    game_manager.on_state_changed.connect(_on_state_changed)
    
func _on_state_changed(state: GameManager.State):
    if state == GameManager.State.Deciding:
        if current_cooldown>0 and cooldown>0:
            current_cooldown-=1
            tooltip.tooltip = "This ability is on cooldown. Remaining turns: %s" % current_cooldown
            if current_cooldown == 0:
                _remove_cooldown()
        else:
            _remove_cooldown()
            
func _remove_cooldown():
    tooltip.tooltip = tooltip_text
    if not can_pay: return
    executed = false
    image.modulate = Color.WHITE  

func _disable():
    executed = true
    image.modulate = Color.DIM_GRAY

func _change_state_because_of_cost():
    if can_pay:
        if current_cooldown >0 and cooldown > 0: return
        _remove_cooldown()
        return
    if not can_pay:
        _disable()
    
func _on_ability_resolver(obj: AbilityResolver):
    resolver = obj

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and\
        event.is_action("click") and is_hover and\
        not executed and can_pay and game_manager.game_state == GameManager.State.Deciding:
            resource_manager.pay_resources(cost)
            resolver.use_ability(ability_function)
            executed = true
            image.modulate = Color.DIM_GRAY
            current_cooldown = cooldown
            if cooldown > 0:
                tooltip.tooltip = "This ability is on cooldown. Remaining turns: %s" % cooldown
