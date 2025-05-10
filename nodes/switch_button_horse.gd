extends Button
class_name SwitchButton
@export var outcomes : Array[String]
@export var outcomeVars : Array[int]
var currVar = 0
var a  = 0
func _ready() -> void:
	text = outcomes[0]

func upd(curr):
	var idx = 0
	for i in outcomeVars:
		if curr == i:
			a = idx
			text = outcomes[a]
			currVar = outcomeVars[a]
		idx += 1


func _process(delta: float) -> void:
	if button_pressed:
		button_pressed = false
		a += 1
		if a > outcomes.size()-1:
			a = 0
		text = outcomes[a]
		currVar = outcomeVars[a]
