extends Resource

class_name BuffData

#@export var damage_multiplier : BuffTypeConfigData
#@export var cooldown_multiplier : BuffTypeConfigData
#@export var healthcap_multiplier : BuffTypeConfigData
#@export var healthregen_multiplier : BuffTypeConfigData

# If any buffs have weird float errors, make sure the expressions resolve as floats
@export var scale_variable = "x"
@export var damage_multiplier_formula = "1.0"
@export var cooldown_multiplier_formula = "1.0"
@export var healthcap_multiplier_formula = "1.0"
@export var healthregen_multiplier_formula = "1.0"


#@export var damage_mult_inc : float = 1.0
#@export var damage_mult_cap : float = 1.0

#@export var cooldown_mult_inc : float = 1.0
#@export var cooldown_mult_cap: float = 1.0

#@export var healthcap_mult_inc : float = 1.0
#@export var healthcap_mult_cap : float = 1.0

#@export var healthregen_mult_inc: float = 1.0
#@export var healthregen_mult_cap: float = 1.0
