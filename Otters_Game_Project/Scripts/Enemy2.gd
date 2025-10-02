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


func enemy2_turn():
	####ENEMY 2 ATTACKS####
	print("Point 2")
	if BattleState.enemy2_status != "dead":
		$AttackEnemy2/AnimationPlayer.play("turn_start")
		display_text("%s attacks" % State.enemy2.name)
		await get_tree().create_timer(1.0). timeout
		
		if BattleState.P1_is_defending:
			BattleState.P1_is_defending = false
			BattleState.current_player_health = max(0, BattleState.current_player_health - State.enemy2.damage/2)
		else:
			BattleState.current_player_health = max(0, BattleState.current_player_health - State.enemy2.damage)
		set_health($"../PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar", BattleState.current_player_health, State.Max_Health)
		$"../PlayerPanel/VBoxContainer/PlayerData/HealthContainer/Label".text = str($"../PlayerPanel/VBoxContainer/PlayerData/HealthContainer/ProgressBar".value)
		
		$"../player/AnimationPlayer".play("player_damaged")
		await($"../player/AnimationPlayer".animation_finished)
		if BattleState.current_player_health <= 0:
			game_over()
		$AttackEnemy2/AnimationPlayer.play("turn_end")
	$"..".player_turn()
