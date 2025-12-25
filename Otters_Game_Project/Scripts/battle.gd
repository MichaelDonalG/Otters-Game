extends Control

var turn_order: Array = []

var player_attack: Array = [
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)], # All rotations are the same
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)], # All rotations are the same
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)], # All rotations are the same
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]  # All rotations are the same
]

func _ready():
	####SET PLAYER START####
	$player.texture = load("res://Art/Battle Icons/"+ State.pos1Char +".png")
	BattleState.curr_player1_speed = State.player1_speed #Set player1 speed for battle
	#Set player Tetris board
	
	
	if State.pos2Char != "empty":
		$player2.show()
		$player2.texture = load("res://Art/Battle Icons/"+State.pos2Char+".png")
		BattleState.curr_player2_speed = State.player2_speed #Set player2 speed for battle
		BattleState.partySize = 2
		$player2.position = Vector2(228,121)
		#Set player2 Tetris board
		if State.pos3Char != "empty":
			$player3.show()
			$player3.texture = load("res://Art/Battle Icons/"+State.pos3Char+".png")
			BattleState.curr_player3_speed = State.player3_speed #Set player3 speed for battle
			BattleState.partySize = 3
			#Set player3 Tetris board
	
	#Add current player board?
	
	
	####SET PLAYER COMPLETE####
	####SET ENEMY START####
	$EnemyContainer/AttackEnemy1.texture_normal = State.enemy1.texture
	BattleState.enemy1_status = true
	BattleState.curr_enemy1_speed = State.enemy1.speed
	
	if State.enemy2 != null:
		
		#Set enemy2 Tetris board
		$EnemyContainer2/AttackEnemy2.texture_normal = State.enemy2.texture
		BattleState.enemy2_status = true
		BattleState.curr_enemy2_speed = State.enemy2.speed
	else:
		BattleState.enemy2_status = false
	
	####SET ENEMY COMPLETE####
	
	####SET TURN ORDER####
	populate_turn_order()
	####TURN ORDER SET####
	
	
	$TextBox.hide()
	$ActionsPanel.hide()
	
	display_text("A wild %s appears!" % State.enemy1.name)
	
	decide_next_turn()

func populate_turn_order() -> void:
	turn_order.append(BattleState.curr_player1_speed)
	turn_order.append(BattleState.curr_enemy1_speed)
	if State.pos2Char != null:
		turn_order.append(BattleState.curr_player2_speed)
		if State.pos3Char != null:
			turn_order.append(BattleState.curr_player3_speed)
	if State.enemy2 != null:
		turn_order.append(BattleState.curr_enemy2_speed)
	print(turn_order)
	organise_turn_order()
	print(turn_order)

func organise_turn_order() -> void:
	turn_order.sort_custom(func(a,b):
		return a>= b
		)

func decide_next_turn() -> void:
	check_if_victory()
	
	if turn_order.is_empty():
		populate_turn_order()
		decide_next_turn()
	else:
		if BattleState.curr_player1_speed == turn_order.front():
			turn_order.pop_front()
			BattleState.playerTurn = 1
			player_turn()
		elif BattleState.curr_player2_speed == turn_order.front():
			turn_order.pop_front()
			BattleState.playerTurn = 2
			player_turn()
		elif BattleState.curr_player3_speed == turn_order.front():
			turn_order.pop_front()
			BattleState.playerTurn = 3
			player_turn()
		elif BattleState.curr_enemy1_speed == turn_order.front():
			turn_order.pop_front()
			$EnemyContainer.enemy_turn()
		elif BattleState.curr_enemy2_speed == turn_order.front():
			turn_order.pop_front()
			$EnemyContainer2.enemy2_turn()

func _input(_event):
	if (Input.is_action_just_pressed("interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible and BattleState.paused == 0:
		$TextBox.hide()
		$ActionsPanel.show()

func display_text(text):
	$TextBox.show()
	$TextBox/Text.text = text


func player_turn():
	BattleState.paused = 0
	$ActionsPanel.show()
	match BattleState.playerTurn:
		1:
			if BattleState.player1_status:
				$player/AnimationPlayer.play("turn_start")
			else:
				decide_next_turn()
		2:
			if BattleState.player2_status:
				$player2/AnimationPlayer.play("turn_start")
			else:
				decide_next_turn()
		3:
			if BattleState.player3_status:
				$player3/AnimationPlayer.play("turn_start")
			else:
				decide_next_turn()

func _on_run_pressed():
	display_text("Got away safely")
	await(get_tree().create_timer(0.5).timeout)
	#Save player boards to state
	get_tree().change_scene_to_file("res://Levels/game_level.tscn")


func _on_attack_pressed():
	BattleState.paused = 1
	display_text("Choose target")
	$EnemyContainer/AttackEnemy1.disabled = false
	$EnemyContainer2/AttackEnemy2.disabled = false



func _on_attack_enemy_1_pressed():
	$EnemyContainer/AttackEnemy1.modulate =  Color(1,1,1,1)
	$EnemyContainer/AttackEnemy1/AnimationPlayer.pause()
	$EnemyContainer/AttackEnemy1.disabled = true
	$EnemyContainer2/AttackEnemy2.disabled = true
	####ATTACK COMMENCES####
	display_text("You attack")
	await get_tree().create_timer(1.0). timeout
	
	match BattleState.playerTurn:
		1:
			#Player attacks with equivilent block
			$EnemyContainer/tetris.next_tetromino_type = player_attack
			$EnemyContainer/tetris.tetris_next_turn()
		2:
			#Player attacks with equivilent block
			$EnemyContainer/tetris.next_tetromino_type = player_attack
			$EnemyContainer/tetris.tetris_next_turn()
		3:
			#Player attacks with equivilent block
			$EnemyContainer/tetris.next_tetromino_type = player_attack
			$EnemyContainer/tetris.tetris_next_turn()
	
	$AnimationPlayer.play("enemy1_damaged")
	await($AnimationPlayer.animation_finished)
	#check if dead
	#if BattleState.enemy1_status == false: #Enemy Tetris board is filled
		#display_text("Enemy defeated!")
		#$AnimationPlayer.play("enemy1_died")
		#await($AnimationPlayer.animation_finished)
		#$EnemyContainer.hide()


func _on_attack_enemy_2_pressed():
	$EnemyContainer2/AttackEnemy2.modulate = Color(1,1,1,1)
	$EnemyContainer2/AttackEnemy2/AnimationPlayer.pause()
	$EnemyContainer/AttackEnemy1.disabled = true
	$EnemyContainer2/AttackEnemy2.disabled = true
	####ATTACK COMMENCES####
	display_text("You attack")
	await get_tree().create_timer(1.0). timeout
	
	match BattleState.playerTurn:
		1:
			#Player attacks with equivilent block
			$EnemyContainer2/tetris.next_tetromino_type = player_attack
			$EnemyContainer2/tetris.tetris_next_turn()
		2:
			#Player attacks with equivilent block
			$EnemyContainer2/tetris.next_tetromino_type = player_attack
			$EnemyContainer2/tetris.tetris_next_turn()
		3:
			#Player attacks with equivilent block
			$EnemyContainer2/tetris.next_tetromino_type = player_attack
			$EnemyContainer2/tetris.tetris_next_turn()
	
	$AnimationPlayer.play("enemy2_damaged")
	await($AnimationPlayer.animation_finished)
	
	#if BattleState.enemy2_status == false:
		#display_text("Enemy defeated!")
		#$AnimationPlayer.play("enemy2_died")
		#await($AnimationPlayer.animation_finished)
		#$EnemyContainer2.hide()
	
	

func check_if_victory():
	match BattleState.playerTurn:
		1:
			$player/AnimationPlayer.play("turn_end")
		2:
			$player2/AnimationPlayer.play("turn_end")
		3:
			$player3/AnimationPlayer.play("turn_end")
	if $EnemyContainer/tetris.is_dead && $EnemyContainer2/tetris.is_dead == false:
		#Save player boards to state
		State.remove_enemy()
		State.reset()
		get_tree().change_scene_to_file("res://Levels/game_level.tscn")

func _on_attack_enemy_1_mouse_entered() -> void:
	if $EnemyContainer/AttackEnemy1.disabled == false:
		$EnemyContainer/AttackEnemy1/AnimationPlayer.play("hover")


func _on_attack_enemy_1_mouse_exited() -> void:
	if $EnemyContainer/AttackEnemy1.disabled == false:
		$EnemyContainer/AttackEnemy1.modulate =  Color(1,1,1,1)
		$EnemyContainer/AttackEnemy1/AnimationPlayer.pause()

func _on_attack_enemy_2_mouse_entered() -> void:
	if $EnemyContainer2/AttackEnemy2.disabled == false:
		$EnemyContainer2/AttackEnemy2/AnimationPlayer.play("hover")


func _on_attack_enemy_2_mouse_exited() -> void:
	if $EnemyContainer2/AttackEnemy2.disabled == false:
		$EnemyContainer2/AttackEnemy2.modulate = Color(1,1,1,1)
		$EnemyContainer2/AttackEnemy2/AnimationPlayer.pause()
