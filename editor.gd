extends Node2D
#BAD CODE AHEAD
@export var camera : Camera2D
@export var tilePage : Array[Item]
@export var peoplePage : Array[Item]
@export var objectsPage : Array[Item]
@export var bgPage : Array[Item]
@onready var itemBar: CanvasLayer = $ItemBar
@onready var currItem = preload("res://resources/floor.tres")
@onready var placer: Area2D = $placer
@onready var placer_sprite: Sprite2D = $placer/placer
@onready var block_node = preload("res://nodes/block_node.tscn")
@onready var noSprite = preload("res://RailHeistSprites/unknownTile.png")
var clearStage = 0
var clearTime = 0
var tempString = ""
var del = 0
func get_ascii():
	#var y = 0 # til 16
	var trainLayout = ""
	trainLayout += "newLevel.missionName = \"" + $"editorButtons/level name".text + "\"\n"
	trainLayout += "newLevel.missionText = \"" + $description/TextEdit.text.replace("\n","") + "\"\n"
	trainLayout += "newLevel.missionTip = \"" +$"editorButtons/level tip".text + "\"\n"
	trainLayout += "newLevel.killMission = " + str($editorButtons/switchButton_Objective.currVar) + "\n"
	if $editorButtons/switchButton_Horse.currVar == 1:
		trainLayout += "newLevel.horse = " + "RIGHT\n"
	else:
		trainLayout += "newLevel.horse = " + "LEFT\n"
	if $editorButtons/switchButton_Rider.currVar == 0:
		trainLayout += "\nnewLevel.horseRider = s13_Maria\n"
	elif $editorButtons/switchButton_Rider.currVar == 1:
		trainLayout += "\nnewLevel.horseRider = s13_Brand\n"
	elif $editorButtons/switchButton_Rider.currVar == 2:
		trainLayout += "\nnewLevel.horseRider = s13_Dodger\n"
	elif $editorButtons/switchButton_Rider.currVar == 3:
		trainLayout += "\nnewLevel.horseRider = s13_Officer\n"
	elif $editorButtons/switchButton_Rider.currVar == 4:
		trainLayout += "\nnewLevel.horseRider = s13_Sheriff\n"
	trainLayout += "newLevel.timeLimit = " + str($editorButtons/time.value) + "\n"
	trainLayout += "newLevel.starGoal = " + str($editorButtons/star.value)+ "\n"
	trainLayout += "newLevel.bulletAmount = " + str($editorButtons/ammo.value)+ "\n"
	trainLayout += "newLevel.moneyGoal = " + str($editorButtons/cashGoal.value)+ "\n"
	var furthestX = 0
	for a in get_tree().get_nodes_in_group("block"):
		if a.e == false:
			if round(a.position.x/16)-4 > furthestX:
				furthestX = round(a.position.x/16)-4
	var col = false
	var block = null
	placer.position = Vector2(56,-32)
	var maps = ceil(float((furthestX+1)/48))
	var p = maps-1
	for off in maps:
		trainLayout += "\nvar trainLayout = \"\""
		for y in 18:
			trainLayout += "\ntrainLayout += \""
			for x in 48:
				col = false
				block = null
				placer.position = (Vector2(x+4,y+2)*16) - Vector2(8,64 )
				placer.position.x += ((48*16)*off) 
				for i in get_tree().get_nodes_in_group("block"):
					if i.position == placer.position:
						col = true
						block = i
				if x == 47 && y == 17:
					trainLayout += "E"
				else:
					if !col:
						trainLayout += " "
					else:
						trainLayout += block.symbol
			trainLayout += "\""
		trainLayout += "\nnewLevel.map[%s] = trainLayout;" % str(int(off))
	tempString = trainLayout
	$saveUtmtTxt.visible = true
	print(trainLayout)



#levels are 17 tiles high, 48 wide
func _process(delta: float) -> void:
	if clearTime > 0:
		clearTime -= 1
		if clearTime == 1:
			clearStage = 0
			$ItemBar/clear.text = "CLEAR"
	if del > 0:
		del -= 1
	placerfunc()
	camera_movement()

func placerfunc():
	if placer.position.y >= 240:
		placer.modulate.a = 0.1
		placer.position = round((get_global_mouse_position()+Vector2(4,0))/16)*16-Vector2(8,0)
		return
	if placer.position.y <= -45:
		placer.modulate.a = 0.1
		placer.position = round((get_global_mouse_position()+Vector2(4,0))/16)*16-Vector2(8,0)
		return
	placer.modulate.a = 0.9
	placer.position = round((get_global_mouse_position()+Vector2(4,0))/16)*16-Vector2(8,0)
	if placer.position.y >= 240:
		placer.modulate.a = 0.1
		placer.position = round((get_global_mouse_position()+Vector2(4,0))/16)*16-Vector2(8,0)
		return
	if placer.position.y <= -45:
		placer.modulate.a = 0.1
		placer.position = round((get_global_mouse_position()+Vector2(4,0))/16)*16-Vector2(8,0)
		return
	for i in placer.get_overlapping_areas():
		if Input.is_action_pressed("erase") && i is BlockNode:
			if i.e == false:
				i.queue_free()
		return
	if Input.is_action_pressed("click") && del == 0:
		del = 1
		var a = block_node.instantiate()
		a.position = placer.position
		a.get_child(0).texture = placer_sprite.texture
		a.get_child(1).texture = currItem.flashSpriteOverlay
		a.get_child(0).offset = placer_sprite.offset
		a.symbol = currItem.symbol
		add_child(a)
		return

func _ready() -> void:
	for i in 4800:
		if i % 48 == 0:
			var e = block_node.instantiate()
			e.position.x = (i * 16)-8
			e.position.y = 224+16
			e.modulate.a = 0.5
			e.e = true
			add_child(e)
	$ItemBar/bar/Label.text = currItem.name.to_upper()
	loadPage(tilePage)

func loadPage(page):
	var idx = 0
	for i in get_tree().get_nodes_in_group("button"):
		i.queue_free()
	for i in page:
		var a = $ItemBar/item.duplicate()
		a.visible = true
		if idx < 25:
			a.position.x += idx * 25
		if idx >= 25:
			a.position.x += (idx-25) * 25
			a.position.y += 25
		a.icon = i.sprite
		a.item = i
		a.add_to_group("button")
		a.tooltip_text = i.name.to_upper()
		if a.icon.get_image().get_size().x > 24:
			a.expand_icon = true
		if a.icon.get_image().get_size().y > 24:
			a.expand_icon = true
		itemBar.add_child(a)
		idx += 1

func camera_movement():
	if Input.is_action_pressed("plus"):
		camera.zoom += Vector2(0.1,0.1)
	if Input.is_action_pressed("minus"):
		camera.zoom -= Vector2(0.1,0.1)
	camera.zoom = clamp(camera.zoom,Vector2(1,1),Vector2(4,4))
	var mov = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	camera.position.x += mov.x*4
	if Input.is_action_pressed("sprint"):
		camera.position.x += mov.x*6
	if camera.position.y > camera.limit_bottom/2:
		camera.position.y = camera.limit_bottom/2
	if camera.position.y < camera.limit_top/2:
		camera.position.y = camera.limit_top/2
	if camera.position.x < camera.limit_left+432:
		camera.position.x = camera.limit_left+432


func _on_item_pressed() -> void:
	for i in get_tree().get_nodes_in_group("button"):
		if i.button_pressed:
			i.button_pressed = false
			currItem = i.item
			$ItemBar/bar/Label.text = currItem.name.to_upper()
			placer_sprite.texture = currItem.sprite
			placer_sprite.offset = currItem.spriteOffset


func _on_floors_pressed() -> void:
	for i in get_tree().get_nodes_in_group("group_button"):
		i.button_pressed = false
	loadPage(tilePage)



func _on_people_pressed() -> void:
	for i in get_tree().get_nodes_in_group("group_button"):
		i.button_pressed = false
	loadPage(peoplePage)


func _on_objects_pressed() -> void:
	for i in get_tree().get_nodes_in_group("group_button"):
		i.button_pressed = false
	loadPage(objectsPage)


func _on_bg_pressed() -> void:
	for i in get_tree().get_nodes_in_group("group_button"):
		i.button_pressed = false
	loadPage(bgPage)


func _on_level_name_text_changed(new_text: String) -> void:
	if $"editorButtons/level name".text != new_text.to_upper():
		var caret_pos = $"editorButtons/level name".caret_column
		$"editorButtons/level name".text = new_text.to_upper()
		$"editorButtons/level name".caret_column = caret_pos


func _on_cancel_pressed() -> void:
	get_tree().paused = false
	$saveType.visible = false


func _on_save_pressed() -> void:
	get_tree().paused = true
	$saveType.visible = true


func _on_trainlayout_pressed() -> void:
	get_ascii()




func _on_description_pressed() -> void:
	get_tree().paused = true
	$description.visible = true


func _on_cancel_desc_pressed() -> void:
	get_tree().paused = false
	$description.visible = false


func _on_level_tip_text_changed(new_text: String) -> void:
	if $"editorButtons/level tip".text != new_text.to_upper():
		var caret_pos = $"editorButtons/level tip".caret_column
		$"editorButtons/level tip".text = new_text.to_upper()
		$"editorButtons/level tip".caret_column = caret_pos



func _on_save_utmt_txt_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(tempString)
	file.close()


func _on_json_pressed() -> void:
	$saveJson.visible = true


func _on_load_json_file_selected(path: String) -> void:
	for i in get_tree().get_nodes_in_group("block"):
		i.queue_free()
	var save_file = FileAccess.open(path, FileAccess.READ)
	var json_string = save_file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON parse error ", json.get_error_message(), " on line ", json.get_error_line())
		return
	var saveData = json.get_data()
	if "missionName" in saveData:
		$"editorButtons/level name".text = saveData.missionName
	if "missionText" in saveData:
		$description/TextEdit.text = saveData.missionText
	if "missionTip" in saveData:
		$"editorButtons/level tip".text = saveData.missionTip
	if "killMission" in saveData:
		$editorButtons/switchButton_Objective.upd(saveData.killMission)
	if "horse" in saveData:
		$editorButtons/switchButton_Horse.upd(saveData.horse)
	if "horseRider" in saveData:
		$editorButtons/switchButton_Rider.upd(saveData.horseRider)
	if "timeLimit" in saveData:
		$editorButtons/time.value = saveData.timeLimit
	if "starGoal" in saveData:
		$editorButtons/star.value = saveData.starGoal
	if "bulletAmount" in saveData:
		$editorButtons/ammo.value = saveData.bulletAmount
	if "moneyGoal" in saveData:
		$editorButtons/cashGoal.value = saveData.moneyGoal
	if "mapData" in saveData:
		loadMap(saveData.mapData)

func getTile(symbol,pos):
	var got = false
	var allTiles = tilePage + peoplePage + objectsPage
	for i in allTiles:
		if i.symbol == symbol:
			var a = block_node.instantiate()
			a.position = pos
			a.get_child(0).texture = i.sprite
			a.get_child(1).texture = i.flashSpriteOverlay
			a.get_child(0).offset = i.spriteOffset
			a.symbol = i.symbol
			add_child(a)
			got = true
	if got == false && symbol != " " && symbol != "E":
		var a = block_node.instantiate()
		a.position = pos
		a.get_child(0).texture = noSprite
		a.symbol = symbol
		add_child(a)

func loadMap(data):
	var off = 0
	for i in data.size():
		off = i * (48*16)
		print(off)
		placer.position = Vector2(56+off,-32-(16*2))
		for j in data[i].length():
			if data[i][j] != "Ф":
				getTile(data[i][j],placer.position)
			placer.position.x += 16
			if data[i][j] == "Ф":
				placer.position.x = 56+off
				placer.position.y += 16

func _on_save_json_file_selected(path: String) -> void:
	var saveData = {
		"missionName" : $"editorButtons/level name".text,
		"missionText" : $description/TextEdit.text,
		"missionTip" : $"editorButtons/level tip".text,
		"killMission" : $editorButtons/switchButton_Objective.currVar,
		"horse" : $editorButtons/switchButton_Horse.currVar,
		"horseRider" : $editorButtons/switchButton_Rider.currVar,
		"timeLimit" : $editorButtons/time.value,
		"starGoal" : $editorButtons/star.value,
		"bulletAmount" : $editorButtons/ammo.value,
		"moneyGoal" : $editorButtons/cashGoal.value,
		"mapData" : []
	}
	var furthestX = 0
	for a in get_tree().get_nodes_in_group("block"):
		if a.e == false:
			if round(a.position.x/16)-4 > furthestX:
				furthestX = round(a.position.x/16)-4
	var col = false
	var block = null
	placer.position = Vector2(56,-32)
	var maps = ceil(float((furthestX+1)/48))
	for off in maps:
		saveData.mapData.append("")
		saveData.mapData[off] += "Ф"
		for y in 18:
			saveData.mapData[off] += "Ф"
			for x in 48:
				col = false
				block = null
				placer.position = (Vector2(x+4,y+2)*16) - Vector2(8,64 )
				placer.position.x += ((48*16)*off) 
				for i in get_tree().get_nodes_in_group("block"):
					if i.position == placer.position:
						col = true
						block = i
				if x == 47 && y == 17:
					saveData.mapData[off] += "E"
				else:
					if !col:
						saveData.mapData[off] += " "
					else:
						saveData.mapData[off] += block.symbol
	print(saveData.mapData)
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(saveData)
	file.store_string(json_string)
	file.close()


func _on_load_pressed() -> void:
	$loadJson.visible = true


func _on_clear_pressed() -> void:
	clearStage += 1
	clearTime = 80
	if clearStage == 1:
		$ItemBar/clear.text = "SURE? (3)"
	if clearStage == 2:
		$ItemBar/clear.text = "SURE? (2)"
	if clearStage == 3:
		$ItemBar/clear.text = "SURE? (1)"
	if clearStage == 4:
		clearStage = 0
		clearTime = 80
		$ItemBar/clear.text = "CLEARED"
		for i in get_tree().get_nodes_in_group("block"):
			i.queue_free()
		$editorButtons/switchButton_Horse.upd(0)
		$editorButtons/switchButton_Rider.upd(0)
		$editorButtons/switchButton_Objective.upd(1)
		$editorButtons/cashGoal.value = 0
		$editorButtons/time.value = 72
		$editorButtons/star.value = 22
		$editorButtons/ammo.value = 0
		$"editorButtons/level name".text = ""
		$"editorButtons/level tip".text = ""
		$description/TextEdit.text = ""
