extends Control

var counter = 1 # Counter for which Position needs to be filled next

func _ready() -> void: # Whenever scene loads remind Menu who is where
	match State.pos1Char: # Check who is now in Pos1 and set the image accordingly 
		"Peepo":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Peepo.png")
			$Row2/Peepo.hide() # Remove Peepo from Row2
		"Starlorn":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Starlorn.png")
			$Row2/Starlorn.hide()
		"Ana":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Ana.png")
			$Row2/Ana.hide()
		"Cyrus":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Cyrus.png")
			$Row2/Cyrus.hide()
		"empty":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/PlayerPosition1.png")
	
	match State.pos2Char: # Check who is now in Pos2 and set the image accordingly 
		"Peepo":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Peepo.png")
			$Row2/Peepo.hide() # Remove Peepo from Row2
		"Starlorn":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Starlorn.png")
			$Row2/Starlorn.hide()
		"Ana":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Ana.png")
			$Row2/Ana.hide()
		"Cyrus":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Cyrus.png")
			$Row2/Cyrus.hide()
		"empty":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/PlayerPosition1.png")
	
	match State.pos3Char: # Check who is now in Pos2 and set the image accordingly 
		"Peepo":
			$Row1/Position3.texture_normal = load("res://Art/Menu Icons/Peepo.png")
			$Row2/Peepo.hide() # Remove Peepo from Row2
		"Starlorn":
			$Row1/Position3.texture_normal = load("res://Art/Menu Icons/Starlorn.png")
			$Row2/Starlorn.hide()
		"Ana":
			$Row1/Position3.texture_normal = load("res://Art/Menu Icons/Ana.png")
			$Row2/Ana.hide()
		"Cyrus":
			$Row1/Position3.texture_normal = load("res://Art/Menu Icons/Cyrus.png")
			$Row2/Cyrus.hide()
		"empty":
			$Row1/Position3.texture_normal = load("res://Art/Menu Icons/PlayerPosition1.png")


func _on_peepo_button_up() -> void:
	if counter < 3: # If there is space
		counter = counter + 1 # Increment
		$Row2/Peepo.hide() # Remove Peepo from Row2
		match counter: # Check which position is next to be filled
			1:
				$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Peepo.png") # Change image to Peepo
				State.pos1Char = "Peepo" # Tell pos1char who was picked
			2:
				$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Peepo.png") # Change image to Peepo
				State.pos2Char = "Peepo" # Tell pos1char who was picked
			3:
				$Row1/Position3.texture_normal = load("res://Art/Menu Icons/Peepo.png") # Change image to Peepo
				State.pos3Char = "Peepo" # Tell pos1char who was picked


func _on_starlorn_button_up() -> void:
	if counter < 3:
		counter = counter + 1
		$Row2/Starlorn.hide()
		match counter: 
			1:
				$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Starlorn.png")
				State.pos1Char = "Starlorn"
			2:
				$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Starlorn.png")
				State.pos2Char = "Starlorn"
			3:
				$Row1/Position3.texture_normal = load("res://Art/Menu Icons/Starlorn.png")
				State.pos3Char = "Starlorn"


func _on_ana_button_up() -> void:
	if counter < 3:
		counter = counter + 1
		$Row2/Ana.hide()
		match counter: 
			1:
				$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Ana.png")
				State.pos1Char = "Ana"
			2:
				$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Ana.png")
				State.pos2Char = "Ana"
			3:
				$Row1/Position3.texture_normal = load("res://Art/Menu Icons/Ana.png")
				State.pos3Char = "Ana"


func _on_cyrus_button_up() -> void:
	if counter < 3:
		counter = counter + 1
		$Row2/Cyrus.hide()
		match counter: 
			1:
				$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Cyrus.png")
				State.pos1Char = "Cyrus"
			2:
				$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Cyrus.png")
				State.pos2Char = "Cyrus"
			3:
				$Row1/Position3.texture_normal = load("res://Art/Menu Icons/Cyrus.png")
				State.pos3Char = "Cyrus"


func _on_button_pressed() -> void: # On back button pressed
	if State.pos1Char != "empty": # Check that someone is in the lead, otherwise do not return to game
		get_tree().paused = false # Unpause game
		$".".hide() # Hide Menu


func _on_position_1_pressed() -> void:
	if counter > 0: # If there is at least one character selected 
		counter = counter - 1 # Decrement
	match State.pos1Char: # Check which character was in this position and return their button to Row2
		"Peepo":
			$Row2/Peepo.show()
		"Starlorn":
			$Row2/Starlorn.show()
		"Ana":
			$Row2/Ana.show()
		"Cyrus":
			$Row2/Cyrus.show()
	
	
	State.pos1Char = State.pos2Char # Whoever was in Pos2 gets moved up to Pos1
	State.pos2Char = State.pos3Char # Whoever was in Pos3 gets moved up to Pos2
	State.pos3Char = "empty" # Position 3 is always emptied when someone is removed
	
	match State.pos1Char: # Check who is now in Pos1 and set the image accordingly 
		"Peepo":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Peepo.png")
		"Starlorn":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Starlorn.png")
		"Ana":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Ana.png")
		"Cyrus":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/Cyrus.png")
		"empty":
			$Row1/Position1.texture_normal = load("res://Art/Menu Icons/PlayerPosition1.png")
	
	match State.pos2Char: # Check who is now in Pos2 and set the image accordingly 
		"Peepo":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Peepo.png")
		"Starlorn":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Starlorn.png")
		"Ana":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Ana.png")
		"Cyrus":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Cyrus.png")
		"empty":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/PlayerPosition1.png")
	
	$Row1/Position3.texture_normal = load("res://Art/Menu Icons/PlayerPosition1.png") # Pos3 will always be emptied


func _on_position_2_pressed() -> void:
	if counter > 0:
		counter = counter - 1
	
	match State.pos2Char:
		"Peepo":
			$Row2/Peepo.show()
		"Starlorn":
			$Row2/Starlorn.show()
		"Ana":
			$Row2/Ana.show()
		"Cyrus":
			$Row2/Cyrus.show()
	
	State.pos2Char = State.pos3Char
	State.pos3Char = "empty"
	
	match State.pos2Char:
		"Peepo":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Peepo.png")
		"Starlorn":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Starlorn.png")
		"Ana":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Ana.png")
		"Cyrus":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/Cyrus.png")
		"empty":
			$Row1/Position2.texture_normal = load("res://Art/Menu Icons/PlayerPosition1.png")
	
	$Row1/Position3.texture_normal = load("res://Art/Menu Icons/PlayerPosition1.png")


func _on_position_3_pressed() -> void:
	if counter > 0:
		counter = counter - 1
	
	match State.pos3Char:
		"Peepo":
			$Row2/Peepo.show()
		"Starlorn":
			$Row2/Starlorn.show()
		"Ana":
			$Row2/Ana.show()
		"Cyrus":
			$Row2/Cyrus.show()
	
	State.pos3Char = "empty"
	
	$Row1/Position3.texture_normal = load("res://Art/Menu Icons/PlayerPosition1.png")
