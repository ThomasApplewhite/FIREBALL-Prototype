extends Resource

class_name SpellData

@export var name : String
@export var icon : Texture2D
@export var packed_spell : PackedScene

@export var cooldown : float
@export var cooldown_multiplier_variable = "x"
@export var cooldown_multiplier_with_level = "1.0"
@export var global_cooldown_change : float
@export var health_change_on_cast : float

@export var damage : float
@export var speed : float

