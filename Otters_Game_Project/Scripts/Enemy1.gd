extends VBoxContainer

var rng = RandomNumberGenerator.new()

func display_text(text):
	$"../TextBox".show()
	$"../TextBox/Text".text = text

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health

func game_over():
	display_text("You have died")
	await(get_tree().create_timer(1).timeout)
	display_text("GAME OVER")
	await(get_tree().create_timer(1).timeout)
	get_tree().quit()

func enemy_turn():
	var chosenMove = rng.randi_range(0,2)
	
	if State.enemy1.moveList[chosenMove].moveType == "melee":
		####ENEMY 1 ATTACKS####
		if BattleState.enemy1_status != "dead":
			$AttackEnemy1/AnimationPlayer.play("turn_start") #Move Sprite forward
			display_text(str(State.enemy1.name, " uses ", State.enemy1.moveList[chosenMove].moveText)) #Displays text based on the enemy and the chosenMove
			await get_tree().create_timer(1.0). timeout
			match BattleState.partySize: #Randomizes what enemy is being attacked based on party size
				1:
					BattleState.enemyTarget = 1
				2:
					BattleState.enemyTarget = rng.randi_range(1,2)
				3:
					BattleState.enemyTarget = rng.randi_range(1,3)
			
			if BattleState.current_player1_health <=0 and BattleState.enemyTarget == 1: #Changes targetted player if current target is downed
				BattleState.enemyTarget = 2
			if BattleState.current_player2_health <=0 and BattleState.enemyTarget == 2:
				BattleState.enemyTarget = 3
			if BattleState.current_player3_health <=0 and BattleState.enemyTarget == 3:
				BattleState.enemyTarget = 1
			
			match BattleState.enemyTarget: #Targets the randomly selected target
				1:
					if BattleState.P1_is_defending:
						BattleState.P1_is_defending = false
						BattleState.current_player1_health = max(0, BattleState.current_player1_health - (State.enemy1.damage*State.enemy1.moveList[chosenMove].effectiveVar/2))
					else:
						BattleState.current_player1_health = max(0, BattleState.current_player1_health - (State.enemy1.damage*State.enemy1.moveList[chosenMove].effectiveVar))
					set_health($"../PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar", BattleState.current_player1_health, State.Max_Health)
					$"../PlayerPanel/VBoxContainer/PlayerData/HealthContainer/Label".text = str($"../PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar".value)
					
					$"../player/AnimationPlayer".play("player_damaged")
					await($"../player/AnimationPlayer".animation_finished)
				2:
					if BattleState.P2_is_defending:
						BattleState.P2_is_defending = false
						BattleState.current_player2_health = max(0, BattleState.current_player2_health - (State.enemy1.damage*State.enemy1.moveList[chosenMove].effectiveVar/2))
					else:
						BattleState.current_player2_health = max(0, BattleState.current_player2_health - (State.enemy1.damage*State.enemy1.moveList[chosenMove].effectiveVar))
					set_health($"../PlayerPanel/VBoxContainer/Player2Data/HealthContainer/ProgressBar", BattleState.current_player2_health, State.Max_Health)
					$"../PlayerPanel/VBoxContainer/Player2Data/HealthContainer/Label".text = str($"../PlayerPanel/VBoxContainer/Player2Data/HealthContainer/ProgressBar".value)
					
					$"../player2/AnimationPlayer".play("player_damaged")
					await($"../player2/AnimationPlayer".animation_finished)
				3:
					if BattleState.P3_is_defending:
						BattleState.P3_is_defending = false
						BattleState.current_player3_health = max(0, BattleState.current_player3_health - (State.enemy1.damage*State.enemy1.moveList[chosenMove].effectiveVar/2))
					else:
						BattleState.current_player3_health = max(0, BattleState.current_player3_health - (State.enemy1.damage*State.enemy1.moveList[chosenMove].effectiveVar))
					set_health($"../PlayerPanel/VBoxContainer/Player3Data/HealthContainer/ProgressBar", BattleState.current_player3_health, State.Max_Health)
					$"../PlayerPanel/VBoxContainer/Player3Data/HealthContainer/Label".text = str($"../PlayerPanel/VBoxContainer/Player3Data/HealthContainer/ProgressBar".value)
					
					$"../player3/AnimationPlayer".play("player_damaged")
					await($"../player3/AnimationPlayer".animation_finished)
			
			
			
		$AttackEnemy1/AnimationPlayer.play("turn_end")  #Move Sprite backwards
	if BattleState.current_player1_health <= 0 and BattleState.current_player2_health <=0 and BattleState.current_player3_health <=0:
			game_over()
	elif State.enemy2 != null:
		$"../EnemyContainer2".enemy2_turn()
	else:
		$"..".player_turn()
