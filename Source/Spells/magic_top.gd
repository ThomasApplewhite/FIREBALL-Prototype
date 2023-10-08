extends Area2D


## How long the spell stays before disappearing
@export
var spell_lifetime = 3.0
## How long the spell moves before its movement asymptotes
@export
var spell_stoptime = 2.0

@onready
var timer = $Timer
@onready
var spell_mover = $LinearSpellMover
@onready
var damage_dealer = $DamageDealer
@onready
var sprite = $Sprite2D

var initial_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_speed = spell_mover.spell_speed
	
	timer.wait_time = spell_lifetime
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var time_elapsed = spell_lifetime - timer.time_left
	spell_mover.spell_speed = calculate_new_spell_speed(time_elapsed)

	# ideal world: make sure the top always faces straight up and down, rather
	# than rotating with the rest of the spell.

func _physics_process(_delta):
	damage_colliding_bodies(get_overlapping_bodies())
	
func _on_timer_timeout():
	queue_free()

func calculate_new_spell_speed(time_elapsed : float) -> float:
	var speed_mod = -(time_elapsed/spell_stoptime) + 1
	return clamp(speed_mod, 0, 1) * initial_speed
	# exponential decay is cool, but is it really necessary?
	# for cool lookingness and juice and having the spell feel nice to use? Yes.
	# for functionality to get things working? No.
	#return spell_lifetime ** (1 - 2* time_elapsed) + 

func damage_colliding_bodies(bodies : Array[Node2D]):
	for body in bodies:
		damage_dealer.damage_node(body)
