extends Node

@export var saveTextTest1:LineEdit
@export var slotNum = 0

func _sceneInit() -> void:
	pass
	#_load_Config()

	#await get_tree().create_timer(0.1).timeout
	

func _ready() -> void:
	pass
	#_load_Config()
	#await get_tree().create_timer(0.1).timeout
	
	#植物Scene+程式數值儲存讀取測試 成功
	#_savePlantArea(1)
	#_loadPlantArea(1)

	#if get_tree().get_current_scene().get_name() == "Xenoflora":
		#_loadPlantArea(GameManager.loadSlot)
	#	_loadPlantArea(1)

	#await get_tree().create_timer(0).timeout
	
func _checkFile(config_path) -> bool:
	var file = FileAccess.open(config_path, FileAccess.READ)
	if file:
		file.close()  # 如果檔案存在，關閉檔案
		return true
	return false

	
func _save_Config(value):
	var config_path = "user://GameConfig.cfg"
	# 設置並儲存 ConfigFile
	var config = ConfigFile.new()
	config.set_value("SaveFile", "GameSettingConfig", value)
	
	if config.save(config_path) == OK:
		print("檔案已成功儲存:", config_path)
	else:
		print("檔案儲存失敗:", config_path)
		
	print("Soad Config")
		
func _load_Config() -> void:
	var config_path = "user://GameConfig.cfg"
	
	var config = ConfigFile.new()

	# 檢查檔案是否存在並讀取
	if config.load(config_path) != OK:
		# 檔案不存在，設定預設值
		print("檔案不存在，將建立新檔案:", config_path)
		
		# 設定預設值
		var settingConfigData = _defaultSettingConfigData()
		# 呼叫傳遞預設配置到設定函數並儲存
		_save_Config(settingConfigData)
		
		print("已儲存預設設定")
		return
	
	# 如果檔案存在，讀取設定
	var settingConfigData = config.get_value("SaveFile", "GameSettingConfig", {})

	 # 驗證資料正確
	var expected_keys = ["ABB", "ABM", "ABX", "last_window_mode", "last_window_size", "locale"]
	var is_valid = true

	for key in expected_keys:
		if not settingConfigData.has(key):
			is_valid = false
			break

	if not is_valid:
		print("玩家設定檔資料異常還原預設值")	
		settingConfigData = _defaultSettingConfigData()
		_save_Config(settingConfigData)
		return
	else:
		# 呼叫傳遞已讀取的設定數據
		var settingPanel = ""
		if get_tree().get_current_scene().get_name() == "Menu":
			settingPanel = get_node("/root/Menu/OptionsMenuPanel/SettingPanel")
		if get_tree().get_current_scene().get_name() == "Xenoflora":
			settingPanel = get_node("/root/Xenoflora/GameUIManager/OptionsMenuPanel/SettingPanel")

		#var settingPanel = get_node("/root/Xenoflora/GameUIManager/OptionsMenuPanel/SettingPanel")
		settingPanel._loadSettingData(settingConfigData)
		print("Load Config")

func _defaultSettingConfigData():
	var settingConfigData = {
		"locale": LocalizationManager._defaultLocale(),
		"last_window_mode": DisplayServer.window_get_mode(),
		"last_window_size": Vector2i(DisplayServer.window_get_size().x,DisplayServer.window_get_size().y),
		"ABM": 0.0,
		"ABB": 0.0,
		"ABX": 0.0,
	}
	return settingConfigData

#-------------------------------

func _on_save_game(value : int) -> void:
	# 加密存檔
	# config.save_encrypted_pass("user://setting.cfg" , key)
	var save_path = "user://player%s/PlayerData.cfg" % str(value)
	var gameData : GameData = GameManager.gameData
	var xfd = GameManager.xenoFloraData
	var config = ConfigFile.new()
	config.set_value("SaveFile", "gameData", gameData)
	config.set_value("SaveFile", "xfData", xfd)
	config.save(save_path)
	print("PlayerData保存完畢")
	_savePlantArea(value)
	
func _on_load_game(value : int) -> void:
	# 加密讀檔
	# var result = config.load_encrypted_pass("user://setting.cfg", key)
	
	var save_path = "user://player%s/PlayerData.cfg" % str(value)
	var config = ConfigFile.new()
	var result = config.load(save_path)
	
	if result == OK:
		var gameData = config.get_value("SaveFile", "gameData")
		var xfd = config.get_value("SaveFile", "xfData")
		
		if gameData != null:
			GameManager.gameData = gameData
		if xfd != null:
			GameManager.xenoFloraData = xfd
		
		print("PlayerData讀取完畢")
		_loadPlantArea(value)
	else:
		print("Failed to load game data from %s" % save_path)

func _on_save_pressed() -> void:
	var config = ConfigFile.new()
	config.set_value("Setting","string1",saveTextTest1.text)
	config.save("user://setting.cfg")
	print("save")
	
	
func _on_load_pressed() -> void:
	var config = ConfigFile.new()
	var result = config.load("user://setting.cfg")
	
	if result == OK:
		saveTextTest1.text = config.get_value("Setting","string1")


#---------------------------------------

func _checkSaveFolder(num,create):
	var directory_path = "user://player%s" % num  # 資料夾路徑
	
	var dir = DirAccess.open("user://player%s" % num)
	if dir:
		print("玩家個別存檔資料夾存在")
		return true
		#
	else:
		print("玩家個別存檔資料夾不存在")
		print("玩家個別存檔資料夾不存在,自動建立")
		if create:
			DirAccess.make_dir_absolute(directory_path)
		return false

#PlantArea儲存/還原Scene"PlantArea"保存玩家種植記錄
func _savePlantArea(num):
	if !_checkSaveFolder(num,true):
		return
	var save_path = "user://player%s/plant_area.tscn" % num
	
	var plant_area = get_node("/root/Xenoflora/PlantArea")
	# 使用 SceneTree 創建 PackedScene
	
	print(plant_area.get_child_count())
	for child in plant_area.get_children():
		child.owner = plant_area
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(plant_area)  # 將 PlantArea 的當前狀態打包成 PackedScene

	# 使用 ResourceSaver 直接保存 PackedScene
	var result = ResourceSaver.save(packed_scene,save_path)
	
	if result == OK:
		print("PlantArea保存成功！")
		_saveScriptData(num)
	else:
		print("PlantArea保存失敗！")

		
func _loadPlantArea(num):
	if !_checkSaveFolder(num,true):
		return
		
	var load_path = "user://player%s/plant_area.tscn" % num

	# 檢查文件是否存在
	if !FileAccess.file_exists(load_path):
		print("檔案不存在，無法加載 PlantArea！")
		return
	
	# 使用 ResourceLoader 加載 PackedScene
	var loaded_scene = ResourceLoader.load(load_path)
	if loaded_scene == null:
		print("場景加載失敗！")
		return
	
	# 確保目標節點存在
	var plant_area = get_node("/root/Xenoflora/PlantArea")
	if plant_area == null:
		print("找不到 PlantArea 節點！")
		return
	
	# 檢查是否有子節點並清空
	if plant_area.get_child_count() > 0:
		for child in plant_area.get_children():
			child.queue_free()
		print("已清空 PlantArea 的子節點")
	else:
		print("PlantArea 沒有子節點，不需清空")
	
	# 實例化場景並將其作為子節點加入到 PlantArea
	
	var instance = loaded_scene.instantiate()
	if instance != null:
		for child in instance.get_children():
			print(child.name)
			child.get_parent().remove_child(child)  #將自身從父物件的子物件移除
			plant_area.add_child(child)
		#plant_area.add_child(instance)
		print("PlantArea 讀取成功！")
		_loadScriptData(num)
	else:
		print("讀取玩家種植實例化失敗！")
		
# 儲存腳本變數到 JSON 檔案
func _saveScriptData(num):
	var save_path = "user://player%s/flora_script_data.json" % num
	var plant_area = get_node("/root/Xenoflora/PlantArea")
	var script_data = {}

	# 遍歷所有子節點並將腳本變數儲存到字典中
	for child in plant_area.get_children():
		if child.has_method("_saveFloraData"):  # 假設有自定義方法來取得變數
			script_data[child.name] = child._saveFloraData()  # 儲存變數值

	# 將字典轉換成 JSON 並保存到檔案
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(script_data))  # 使用 JSON.stringify
		file.close()
		print("SceneFlora變數已保存")
	else:
		print("無法儲存腳本變數")
		
# 加載腳本變數從 JSON 檔案
func _loadScriptData(num):
	var load_path = "user://player%s/flora_script_data.json" % num
	var file = FileAccess.open(load_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		# 使用 JSON 實例來解析 JSON 字串
		var json_parser = JSON.new()
		var parse_result = json_parser.parse(json_string)
		if parse_result == OK:
			var plant_area = get_node("/root/Xenoflora/PlantArea")
			for key in json_parser.get_data().keys():
				var child = plant_area.get_node(key)
				if child:
					child._loadFloraData(json_parser.get_data()[key])  # 設置變數值
					print("script變數已加載：", key)
		else:
			print("無效的 JSON 格式")
	else:
		print("檔案不存在無法加載腳本變數")
