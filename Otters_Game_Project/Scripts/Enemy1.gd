extends VBoxContainer

var rng = RandomNumberGenerator.new()

func display_text(text):
	$"../TextBox".show()
	$"../TextBox/Text".text = text


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
		if BattleState.enemy1_status != false:
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
			
			if BattleState.player1_status == false and BattleState.enemyTarget == 1: #Changes targetted player if current target is downed
				BattleState.enemyTarget = 2
			if BattleState.player2_status == false and BattleState.enemyTarget == 2:
				BattleState.enemyTarget = 3
			if BattleState.player3_status == false and BattleState.enemyTarget == 3:
				BattleState.enemyTarget = 1
			
			match BattleState.enemyTarget: #Targets the randomly selected target
				1:
					#Play tetris on player 1
					$"../player/tetris".next_tetromino_type = State.enemy1.moveList[chosenMove].damageType
					$"../player/tetris".tetris_next_turn()
					
					$"../player/AnimationPlayer".play("player_damaged")
					await($"../player/AnimationPlayer".animation_finished)
				2:
					#Play tetris on player 2
					$"../player2/tetris".next_tetromino_type = State.enemy1.moveList[chosenMove].damageType
					$"../player2/tetris".tetris_next_turn()
					
					$"../player2/AnimationPlayer".play("player_damaged")
					await($"../player2/AnimationPlayer".animation_finished)
				3:
					#Play tetris on player 3
					$"../player3/tetris".next_tetromino_type = State.enemy1.moveList[chosenMove].damageType
					$"../player3/tetris".tetris_next_turn()
					
					$"../player3/AnimationPlayer".play("player_damaged")
					await($"../player3/AnimationPlayer".animation_finished)
			
			
			
		$AttackEnemy1/AnimationPlayer.play("turn_end")  #Move Sprite backwards
	if $"../player/tetris".is_dead and $"../player2/tetris".is_dead and $"../player3/tetris".is_dead:
			game_over()
	else:
		$"..".decide_next_turn()
