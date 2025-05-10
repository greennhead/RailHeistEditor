extends Node2D
var editor = "res://nodes/editor.tscn"
var creditsOpened = 0


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(editor)


func _on_credits_pressed() -> void:
	if creditsOpened < 20:
		$creditsTab.visible = !$creditsTab.visible
		creditsOpened += 1
	else:
		$creditsTab/Label/Button.visible = false
		$creditsTab.visible = true
		$creditsTab/Label.text = "PLAY CRABWAR2 AND DATAMINER"


func _on_quit_pressed() -> void:
	get_tree().exit()


func _on_button_pressed() -> void:
	OS.shell_open("https://docs.google.com/spreadsheets/d/1kOPezgu-98HKJFO3iuGZcsjmt2jsV7Dio9fv5fsM0YY/edit?gid=1792347532#gid=1792347532")
