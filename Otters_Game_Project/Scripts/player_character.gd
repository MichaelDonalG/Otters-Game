extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var all_interactions = []
@onready var interactLabel = $InteractionComponents/InteractLabel

const MOVE_DOWN : Vector2 = Vector2(0,1)
const MOVE_UP : Vector2 = Vector2(0,-1)
const MOVE_LEFT : Vector2 = Vector2(-1,0)
const MOVE_RIGTH : Vector2 = Vector2(1,0)

var text_array = Array()
var text_counter = 0

var follower_counter = 0

func _ready():
	update_animation_paramaeters(starting_direction)
	match State.pos1Char:
		"Peepo":
			$Sprite2D.texture = load("res://Art/Peepo/peepo.png")
		"Starlorn":
			$Sprite2D.texture = load("res://Art/Starlorn/Starlorn.png")
		"Ana":
			$Sprite2D.texture = load("res://Art/Ana/Ana.png")
		"Cyrus":
			$Sprite2D.texture = load("res://Art/Cyrus/Cyrus.png")
	if (State.playerx != null):
		position.x = State.playerx
		position.y = State.playery
		State.playerx = null
		State.playery = null
		State.enemy2 = null
	set_health()


#########################Player Movement#########################

func _physics_process(_delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == false:
			get_tree().paused = true
			$Character_select_menu.show()
	
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
				$TextBox.show()
				text_array = cur_interaction.text
				if text_array.is_empty() == false:
					$TextBox/Text.text = text_array[text_counter]
					get_tree().paused = true
			"bed" :
				interactLabel.text = "Feeling rested"
				State.P1_current_health = State.P1_max_health
				set_health() 

###############UI Functions#############
func set_health():
	$PlayerPanel/VBoxContainer/PlayerData/Label.text = State.pos1Char
	$PlayerPanel/VBoxContainer/PlayerData/ProgressBar.value = State.P1_current_health
	$PlayerPanel/VBoxContainer/PlayerData/ProgressBar.max_value = State.P1_max_health
	if State.pos2Char == "empty":
		$PlayerPanel/VBoxContainer/PlayerData2/Label.text = "empty"
		$PlayerPanel/VBoxContainer/PlayerData2.hide()
		$PlayerPanel/VBoxContainer/PlayerData3.hide()
	else:
		$PlayerPanel/VBoxContainer/PlayerData2/Label.text = State.pos2Char
		$PlayerPanel/VBoxContainer/PlayerData2.show()
		$PlayerPanel/VBoxContainer/PlayerData3.show()
		
		$PlayerPanel/VBoxContainer/PlayerData2/ProgressBar.value = State.P2_current_health
		$PlayerPanel/VBoxContainer/PlayerData2/ProgressBar.max_value = State.P2_max_health
		
		if State.pos3Char == "empty":
			$PlayerPanel/VBoxContainer/PlayerData3/Label.text = "empty"
			$PlayerPanel/VBoxContainer/PlayerData3.hide()
		else:
			$PlayerPanel/VBoxContainer/PlayerData3/Label.text = State.pos3Char
			$PlayerPanel/VBoxContainer/PlayerData3/ProgressBar.value = State.P1_current_health
			$PlayerPanel/VBoxContainer/PlayerData3/ProgressBar.max_value = State.P1_max_health

################Follower Functions######################
func add_point_to_path(new_point: Vector2):
	$"../Path2D".curve.add_point(new_point)

func remove_point_from_path(index: int):
	$"../Path2D".curve.remove_point(index)


func _on_character_select_menu_gui_input(event: InputEvent) -> void:
	set_health()
	match State.pos1Char:
		"Peepo":
			$Sprite2D.texture = load("res://Art/Peepo/peepo.png")
		"Starlorn":
			$Sprite2D.texture = load("res://Art/Starlorn/Starlorn.png")
		"Ana":
			$Sprite2D.texture = load("res://Art/Ana/Ana.png")
		"Cyrus":
			$Sprite2D.texture = load("res://Art/Cyrus/Cyrus.png")


func _on_button_pressed() -> void:
	if text_array.size() == text_counter+1:
		text_counter = 0
		get_tree().paused = false
		$TextBox.hide()
	else:
		text_counter = text_counter + 1
		$TextBox/Text.text = text_array[text_counter]
