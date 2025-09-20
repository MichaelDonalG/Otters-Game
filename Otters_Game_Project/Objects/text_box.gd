extends Panel

var text_array: Array
var text counter = 0

func _on_button_pressed() -> void:
	
	if text_array.size() == text_counter+1:
		text_counter = 0
		get_tree().paused = false
		$".".hide()
	else:
		text_counter = text_counter + 1
		$Text.text = text_array[text_counter]
		$AnimationPlayer.play("box_shake")
