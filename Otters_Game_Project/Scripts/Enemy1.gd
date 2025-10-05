extends VBoxContainer


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
	####ENEMY 1 ATTACKS####
	if BattleState.enemy1_status != "dead":
		$AttackEnemy1/AnimationPlayer.play("turn_start") #Move Sprite forward
		display_text("%s attacks" % State.enemy1.name)
		await get_tree().create_timer(1.0). timeout
		
		if BattleState.P1_is_defending:
			BattleState.P1_is_defending = false
			BattleState.current_player_health = max(0, BattleState.current_player_health - State.enemy1.damage/2)
		else:
			BattleState.current_player_health = max(0, BattleState.current_player_health - State.enemy1.damage)
		set_health($"../PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar", BattleState.current_player_health, State.Max_Health)
		$"../PlayerPanel/VBoxContainer/PlayerData/HealthContainer/Label".text = str($"../PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar".value)
		
		$"../player/AnimationPlayer".play("player_damaged")
		await($"../player/AnimationPlayer".animation_finished)
		
		$AttackEnemy1/AnimationPlayer.play("turn_end")  #Move Sprite backwards
	if BattleState.current_player_health <= 0:
			game_over()
	elif State.enemy2 != null:
		$"../EnemyContainer2".enemy2_turn()
	else:
		$"..".player_turn()
