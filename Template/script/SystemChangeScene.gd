extends Node
	
func _changeScene(value: String):
	#print(value)
	Engine.time_scale = 1.0 # 重置時間縮放
	#var path = "res://Scene/GameScene/${value}.tscn"
	var path = "res://scene/%s.tscn" % value
	await get_tree().process_frame
	get_tree().change_scene_to_file(path)
	#print(path)

func _changeSceneUID(value: String):
	#print(value)
	#var path = "res://Scene/GameScene/${value}.tscn"
	var path = value
	get_tree().change_scene_to_file(path)
	#print(path)

func _reloadScene():
	#print("_reloadScene")
	get_tree().reload_current_scene()

func _changeSceneGM(scene_name, state , slot):
	#print("_changeSceneGM")
	GameManager.enterState = state
	GameManager.loadSlot = slot
	_changeScene(scene_name)

func _reloadSceneGM(slot):
	#print("_reloadSceneGM")
	GameManager.enterState = 1
	GameManager.loadSlot = slot
	get_tree().reload_current_scene()

	


func _on_button_pressed() -> void:
	pass # Replace with function body.
