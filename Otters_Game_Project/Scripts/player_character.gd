extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var all_interactions = []
@onready var interactLabel = $InteractionComponents/InteractLabel

const MOVE_DOWN : Vector2 = Vector2(0,1)
const MOVE_UP : Vector2 = Vector2(0,-1)
const MOVE_LEFT : Vector2 = Vector2(-1,0)
const MOVE_RIGTH : Vector2 = Vector2(1,0)

var follower_counter = 0

func _ready():
	update_animation_paramaeters(starting_direction)
	if (State.playerx != null):
		position.x = State.playerx
		position.y = State.playery
		State.playerx = null
		State.playery = null
		State.enemy2 = null
	set_health($"../Camera2D/PlayerPanel/PlayerData/ProgressBar")

#########################Player Movement#########################

func _physics_process(_delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	
	update_animation_paramaeters(input_direction)
	
	#print(input_direction)
	# Update velocity
	velocity = input_direction * move_speed
	# Move and slide function uses velocity of character body to move character on map
	move_and_slide()
	
	
	####################Follower Code###################
	add_point_to_path(Vector2(position.x, position.y))
	if $"../Path2D/PathFollow2D".progress_ratio <= .5:
		$"../Path2D/PathFollow2D".progress_ratio  += .1 * _delta
	else:
		$"../Path2D/PathFollow2D".progress_ratio = .5
	if $"../Path2D".curve.get_point_count() >= 10:
		remove_point_from_path(0)
	
	

func update_animation_paramaeters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		match move_input:
			MOVE_DOWN:
				$AnimationPlayer.play("walk_down")
			MOVE_UP:
				$AnimationPlayer.play("walk_up")
			MOVE_LEFT:
				$AnimationPlayer.play("walk_left")
			MOVE_RIGTH:
				$AnimationPlayer.play("walk_right")
	else:
		match move_input:
			MOVE_DOWN:
				$AnimationPlayer.play("idle_down")
			MOVE_UP:
				$AnimationPlayer.play("idle_up")
			MOVE_LEFT:
				$AnimationPlayer.play("idle_left")
			MOVE_RIGTH:
				$AnimationPlayer.play("idle_right")

#########################Inteactions#########################

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		interactLabel.text = all_interactions[0].interact_label
	else:
		interactLabel.text = ""

func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match  cur_interaction.interact_type:
			"chest" : 
				interactLabel.text = "Empty..."
			"bed" :
				interactLabel.text = "Feeling rested"
				State.current_health = State.max_health
				set_health($"../Camera2D/PlayerPanel/PlayerData/ProgressBar") 

###############UI Functions#############
func set_health(progress_bar):
	progress_bar.value = State.current_health
	progress_bar.max_value = State.max_health

################Follower Functions######################
func add_point_to_path(new_point: Vector2):
	$"../Path2D".curve.add_point(new_point)

func remove_point_from_path(index: int):
	$"../Path2D".curve.remove_point(index)
