extends Area2D
class_name BlockNode
@onready var sprite: Sprite2D = $Sprite2D
@onready var es = preload("res://RailHeistSprites/E.png")
var symbol = ""
var e = false
func _ready() -> void:
	add_to_group(str(round((position.y/16)+2)))
	if e:
		symbol = "E"
		remove_from_group("block")
		remove_from_group(str(round((position.y/16)+2)))
		sprite.texture = es
	if $flashSprite.texture == null:
		$flashSprite.queue_free()
		$AnimationPlayer.queue_free()
