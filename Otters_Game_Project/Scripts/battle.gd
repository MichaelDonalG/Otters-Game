extends Control


func _ready():
	BattleState.playerTurn = 1
	
	####SET PLAYER START####
	$player.texture = load("res://Art/Battle Icons/"+ State.pos1Char +".png")
	set_health($PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar, State.P1_current_health, State.Max_Health) 
	$PlayerPanel/VBoxContainer/PlayerData/HealthContainer/Label.text = str($PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar.value)
	if State.pos2Char != "empty":
		$player2.show()
		$PlayerPanel/VBoxContainer/Player2Data.show()
		$player2.texture = load("res://Art/Battle Icons/"+State.pos2Char+".png")
		BattleState.partySize = 2
		$player2.position = Vector2(228,121)
		set_health($PlayerPanel/VBoxContainer/Player2Data/HealthContainer/ProgressBar,State.P2_current_health, State.Max_Health)
		$PlayerPanel/VBoxContainer/Player2Data/HealthContainer/Label.text = str($PlayerPanel/VBoxContainer/Player2Data/HealthContainer/ProgressBar.value)
		if State.pos3Char != "empty":
			$player3.show()
			$PlayerPanel/VBoxContainer/Player3Data.show()
			$player3.texture = load("res://Art/Battle Icons/"+State.pos3Char+".png")
			BattleState.partySize = 3
			set_health($PlayerPanel/VBoxContainer/Player3Data/HealthContainer/ProgressBar, State.P3_current_health, State.Max_Health)
			$PlayerPanel/VBoxContainer/Player3Data/HealthContainer/Label.text = str($PlayerPanel/VBoxContainer/Player3Data/HealthContainer/ProgressBar.value)
	
	
	BattleState.current_player_health = State.P1_current_health
	
	####SET PLAYER COMPLETE####
	####SET ENEMY START####
	set_health($EnemyContainer/VBoxContainer/ProgressBar, State.enemy1.health, State.enemy1.health)
	$EnemyContainer/AttackEnemy1.texture_normal = State.enemy1.texture
	BattleState.enemy1_status = "alive"
	
	BattleState.enemy1_health = State.enemy1.health
	
	$EnemyContainer/VBoxContainer/ProgressBar.visible = true
	
	if State.enemy2 != null:
		
		set_health($EnemyContainer2/VBoxContainer/ProgressBar, State.enemy2.health, State.enemy2.health)
		$EnemyContainer2/AttackEnemy2.texture_normal = State.enemy2.texture
		BattleState.enemy2_status = "alive"
		
		BattleState.enemy2_health = State.enemy2.health
		
		$EnemyContainer2/VBoxContainer/ProgressBar.visible = true
	else:
		BattleState.enemy2_status = "dead"
	
	####SET ENEMY COMPLETE####
	$TextBox.hide()
	$ActionsPanel.hide()
	
	display_text("A wild %s appears!" % State.enemy1.name)
	player_turn()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health


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
			$player/AnimationPlayer.play("turn_start")
		2:
			$player2/AnimationPlayer.play("turn_start")
		3:
			$player3/AnimationPlayer.play("turn_start")

func _on_run_pressed():
	display_text("Got away safely")
	await(get_tree().create_timer(0.5).timeout)
	State.P1_current_health = BattleState.current_player_health
	get_tree().change_scene_to_file("res://Levels/game_level.tscn")


func _on_attack_pressed():
	BattleState.paused = 1
	display_text("Choose target")
	$EnemyContainer/AttackEnemy1.disabled = false
	$EnemyContainer2/AttackEnemy2.disabled = false

func _on_defend_pressed():
	match BattleState.playerTurn:
		1:
			BattleState.P1_is_defending = true
		2:
			BattleState.P2_is_defending = true
		3:
			BattleState.P3_is_defending = true
	
	display_text("You defend")
	BattleState.paused = 1
	await get_tree().create_timer(1.0). timeout
	
	check_if_victory()


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
			BattleState.enemy1_health = max(0, BattleState.enemy1_health - State.P1_damage)
		2:
			BattleState.enemy1_health = max(0, BattleState.enemy1_health - State.P2_damage)
		3:
			BattleState.enemy1_health = max(0, BattleState.enemy1_health - State.P3_damage)
	set_health($EnemyContainer/VBoxContainer/ProgressBar, BattleState.enemy1_health, State.enemy1.health)
	
	$AnimationPlayer.play("enemy1_damaged")
	await($AnimationPlayer.animation_finished)
	
	if BattleState.enemy1_health <= 0:
		BattleState.enemy1_status = "dead"
		display_text("Enemy defeated!")
		$AnimationPlayer.play("enemy1_died")
		await($AnimationPlayer.animation_finished)
		$EnemyContainer.hide()
	
	
	check_if_victory()


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
			BattleState.enemy2_health = max(0, BattleState.enemy2_health - State.P1_damage)
		2:
			BattleState.enemy2_health = max(0, BattleState.enemy2_health - State.P2_damage)
		3:
			BattleState.enemy2_health = max(0, BattleState.enemy2_health - State.P3_damage)
	set_health($EnemyContainer2/VBoxContainer/ProgressBar, BattleState.enemy2_health, State.enemy2.health)
	
	$AnimationPlayer.play("enemy2_damaged")
	await($AnimationPlayer.animation_finished)
	
	if BattleState.enemy2_health <= 0:
		BattleState.enemy2_status = "dead"
		display_text("Enemy defeated!")
		$AnimationPlayer.play("enemy2_died")
		await($AnimationPlayer.animation_finished)
		$EnemyContainer2.hide()
	
	check_if_victory()

func check_if_victory():
	match BattleState.playerTurn:
		1:
			$player/AnimationPlayer.play("turn_end")
		2:
			$player2/AnimationPlayer.play("turn_end")
		3:
			$player3/AnimationPlayer.play("turn_end")
	if BattleState.enemy1_status == "dead" && BattleState.enemy2_status == "dead":
		State.P1_current_health = BattleState.current_player_health
		State.remove_enemy()
		State.reset()
		get_tree().change_scene_to_file("res://Levels/game_level.tscn")
	else:
		if BattleState.playerTurn == BattleState.partySize:
			BattleState.playerTurn = 1
			$EnemyContainer.enemy_turn()
		else:
			BattleState.playerTurn = BattleState.playerTurn+1
			player_turn()

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
