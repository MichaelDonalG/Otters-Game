extends Control

signal textbox_closed

var enemy1 = State.enemy1
var enemy2 = State.enemy2


var enemy1_health = 0
var enemy2_health = 0
var enemy1_status = "alive"
var enemy2_status = "alive"

var current_player_health = 0
var P1_is_defending = false
var P2_is_defending = false
var P3_is_defending = false
var playerTurn = 1
var partySize = 1

var paused = 0

func _ready():
	
	
	####SET PLAYER START####
	$player.texture = load("res://Art/Battle Icons/"+ State.pos1Char +".png")
	set_health($PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar, State.P1_current_health, State.Max_Health) 
	$PlayerPanel/VBoxContainer/PlayerData/HealthContainer/Label.text = str($PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar.value)
	if State.pos2Char != "empty":
		$player2.show()
		$PlayerPanel/VBoxContainer/Player2Data.show()
		$player2.texture = load("res://Art/Battle Icons/"+State.pos2Char+".png")
		partySize = 2
		$player2.position = Vector2(228,121)
		set_health($PlayerPanel/VBoxContainer/Player2Data/HealthContainer/ProgressBar,State.P2_current_health, State.Max_Health)
		$PlayerPanel/VBoxContainer/Player2Data/HealthContainer/Label.text = str($PlayerPanel/VBoxContainer/Player2Data/HealthContainer/ProgressBar.value)
		if State.pos3Char != "empty":
			$player3.show()
			$PlayerPanel/VBoxContainer/Player3Data.show()
			$player3.texture = load("res://Art/Battle Icons/"+State.pos3Char+".png")
			partySize = 3
			set_health($PlayerPanel/VBoxContainer/Player3Data/HealthContainer/ProgressBar, State.P3_current_health, State.Max_Health)
			$PlayerPanel/VBoxContainer/Player3Data/HealthContainer/Label.text = str($PlayerPanel/VBoxContainer/Player3Data/HealthContainer/ProgressBar.value)
	
	
	current_player_health = State.P1_current_health
	
	####SET PLAYER COMPLETE####
	####SET ENEMY START####
	set_health($EnemyContainer/VBoxContainer/ProgressBar, enemy1.health, enemy1.health)
	$EnemyContainer/AttackEnemy1.texture_normal = enemy1.texture
	
	enemy1_health = enemy1.health
	
	$EnemyContainer/VBoxContainer/ProgressBar.visible = true
	
	if enemy2 != null:
		
		set_health($EnemyContainer2/VBoxContainer/ProgressBar, enemy2.health, enemy2.health)
		$EnemyContainer2/AttackEnemy2.texture_normal = enemy2.texture
		
		enemy2_health = enemy2.health
		
		$EnemyContainer2/VBoxContainer/ProgressBar.visible = true
	else:
		enemy2_status = "dead"
	
	####SET ENEMY COMPLETE####
	$TextBox.hide()
	$ActionsPanel.hide()
	
	display_text("A wild %s appears!" % enemy1.name)
	player_turn()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health


func _input(event):
	if (Input.is_action_just_pressed("interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible and paused == 0:
		$TextBox.hide()
		$ActionsPanel.show()

func display_text(text):
	$TextBox.show()
	$TextBox/Text.text = text


func enemy_turn():
	
	
	
	####ENEMY 1 ATTACKS####
	if enemy1_status != "dead":
		$EnemyContainer/AttackEnemy1/AnimationPlayer.play("turn_start") #Move Sprite forward
		display_text("%s attacks" % enemy1.name)
		await get_tree().create_timer(1.0). timeout
		
		if P1_is_defending:
			P1_is_defending = false
			current_player_health = max(0, current_player_health - enemy1.damage/2)
		else:
			current_player_health = max(0, current_player_health - enemy1.damage)
		set_health($PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar, current_player_health, State.Max_Health)
		$PlayerPanel/VBoxContainer/PlayerData/HealthContainer/Label.text = str($PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar.value)
		
		$player/AnimationPlayer.play("player_damaged")
		await($player/AnimationPlayer.animation_finished)
		if current_player_health <= 0:
			game_over()
		$EnemyContainer/AttackEnemy1/AnimationPlayer.play("turn_end")  #Move Sprite backwards
	
	####ENEMY 2 ATTACKS####
	if enemy2_status != "dead":
		$EnemyContainer2/AttackEnemy2/AnimationPlayer.play("turn_start")
		display_text("%s attacks" % enemy2.name)
		await get_tree().create_timer(1.0). timeout
		
		if P1_is_defending:
			P1_is_defending = false
			current_player_health = max(0, current_player_health - enemy2.damage/2)
		else:
			current_player_health = max(0, current_player_health - enemy2.damage)
		set_health($PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar, current_player_health, State.Max_Health)
		$PlayerPanel/VBoxContainer/PlayerData/HealthContainer/Label.text = str($PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar.value)
		
		$player/AnimationPlayer.play("player_damaged")
		await($player/AnimationPlayer.animation_finished)
		if current_player_health <= 0:
			game_over()
		$EnemyContainer2/AttackEnemy2/AnimationPlayer.play("turn_end")
	player_turn()

func player_turn():
	paused = 0
	$ActionsPanel.show()
	match playerTurn:
		1:
			$player/AnimationPlayer.play("turn_start")
		2:
			$player2/AnimationPlayer.play("turn_start")
		3:
			$player3/AnimationPlayer.play("turn_start")

func _on_run_pressed():
	display_text("Got away safely")
	await(get_tree().create_timer(0.5).timeout)
	State.P1_current_health = current_player_health
	get_tree().change_scene_to_file("res://Levels/game_level.tscn")


func _on_attack_pressed():
	paused = 1
	display_text("Choose target")
	$EnemyContainer/AttackEnemy1.disabled = false
	$EnemyContainer2/AttackEnemy2.disabled = false

func _on_defend_pressed():
	match playerTurn:
		1:
			P1_is_defending = true
		2:
			P2_is_defending = true
		3:
			P3_is_defending = true
	
	display_text("You defend")
	paused = 1
	await get_tree().create_timer(1.0). timeout
	
	check_if_victory()


func _on_attack_enemy_1_pressed():
	$EnemyContainer/AttackEnemy1.disabled = true
	$EnemyContainer2/AttackEnemy2.disabled = true
	####ATTACK COMMENCES####
	display_text("You attack")
	await get_tree().create_timer(1.0). timeout
	
	match playerTurn:
		1:
			enemy1_health = max(0, enemy1_health - State.P1_damage)
		2:
			enemy1_health = max(0, enemy1_health - State.P2_damage)
		3:
			enemy2_health = max(0, enemy2_health - State.P3_damage)
	set_health($EnemyContainer/VBoxContainer/ProgressBar, enemy1_health, enemy1.health)
	if enemy2 != null:
		set_health($EnemyContainer2/VBoxContainer/ProgressBar, enemy2_health, enemy2.health)
	
	$AnimationPlayer.play("enemy1_damaged")
	await($AnimationPlayer.animation_finished)
	
	if enemy1_health <= 0:
		enemy1_status = "dead"
		display_text("Enemy defeated!")
		$AnimationPlayer.play("enemy1_died")
		await($AnimationPlayer.animation_finished)
		$EnemyContainer.hide()
	
	
	check_if_victory()


func _on_attack_enemy_2_pressed():
	$EnemyContainer/AttackEnemy1.disabled = true
	$EnemyContainer2/AttackEnemy2.disabled = true
	####ATTACK COMMENCES####
	display_text("You attack")
	await get_tree().create_timer(1.0). timeout
	
	match playerTurn:
		1:
			enemy2_health = max(0, enemy2_health - State.P1_damage)
		2:
			enemy2_health = max(0, enemy2_health - State.P2_damage)
		3:
			enemy2_health = max(0, enemy2_health - State.P3_damage)
	set_health($EnemyContainer2/VBoxContainer/ProgressBar, enemy2_health, enemy2.health)
	
	$AnimationPlayer.play("enemy2_damaged")
	await($AnimationPlayer.animation_finished)
	
	if enemy2_health <= 0:
		enemy2_status = "dead"
		display_text("Enemy defeated!")
		$AnimationPlayer.play("enemy2_died")
		await($AnimationPlayer.animation_finished)
		$EnemyContainer2.hide()
	
	check_if_victory()

func check_if_victory():
	match playerTurn:
		1:
			$player/AnimationPlayer.play("turn_end")
		2:
			$player2/AnimationPlayer.play("turn_end")
		3:
			$player3/AnimationPlayer.play("turn_end")
	if enemy1_status == "dead" && enemy2_status == "dead":
		State.P1_current_health = current_player_health
		State.remove_enemy()
		get_tree().change_scene_to_file("res://Levels/game_level.tscn")
	else:
		if playerTurn == partySize:
			playerTurn = 1
			enemy_turn()
		else:
			playerTurn = playerTurn+1
			player_turn()

func game_over():
	display_text("You have died")
	await(get_tree().create_timer(1).timeout)
	display_text("GAME OVER")
	await(get_tree().create_timer(1).timeout)
	get_tree().quit()

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
