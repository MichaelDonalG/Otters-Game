extends CharacterBody2D

const MOVE_DOWN : Vector2 = Vector2(0,1)
const MOVE_UP : Vector2 = Vector2(0,-1)
const MOVE_LEFT : Vector2 = Vector2(-1,0)
const MOVE_RIGTH : Vector2 = Vector2(1,0)



func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	
	update_animation_paramaeters(input_direction)
	
	
	move_and_slide()
	
	
	
	


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
