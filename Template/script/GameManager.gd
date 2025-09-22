#!GM
#@tool
extends Node

#class_name GameManager
var gameData : GameData = GameData.new()
#玩家破到第幾關 預設0
var currentLevel : int = 0
var currentLevelGS: int:
	get:
		return currentLevel
	set(value):
		currentLevel = value
		#print("已更改GM數值currentLevel:", value)

#玩家選擇第幾關
var selectLevel: int = 0
var selectLevelGS: int:
	get:
		return selectLevel
	set(value):
		selectLevel = value
		#print("已更改GM數值selectLevel:", value)  # 這裡可以換成你需要的處理邏輯

var unlock_unit_cost_table := [
	10,   # 第0關：初始 cost 上限
	15,   # 第1關
	20,   # 第2關
	30 ,   # 第3關
	35,   # 第4關
	40,   # 第5關
	45,   # 第6關
	50,   # 第7關
	55,   # 第8關
	60   # 第9關
]
func get_unlock_unit_cost() -> int:
	if currentLevelGS < unlock_unit_cost_table.size():
		return unlock_unit_cost_table[currentLevelGS]
	else:
		push_error("取得unlock_unit_cost失敗！")
		return 0  # 或預設值

#14戰鬥單位 + 2~3牆壁單位
#1拋物線弓箭 1直線槍
#2拋物線岩石 2直線連續冰錐
#1拋物線火球 1直線雷球
#拋物線攻城弩 直線火炮
#直線黑洞 直線穿透炮
#前方護盾 群體護盾
#建築維修 單位補血
#1牆/2牆/3牆

#0 1拋物線弓箭 1牆 #0 2
#1 1直線槍 前方護盾  #1 3
#2 1拋物線火球 1直線雷球 #4 5
#3 2拋物線岩石 2直線連續冰錐 #6 7 Rock Ball / Icicle
#4 3拋物線攻城弩 群體護盾 # 8 9 Ballista / GroupShield
#5 3直線火炮 單位補血  #10 11 artillery / Heal
#6 建築維修 2牆 #12 13 Repair
#7 直線黑洞 #14 GravitationalBall Gravity
#8 直線穿透炮 #15 Pierc
#9

#一盤 x-144~144 Y5
#二樓 左X -146~-84  -30~30 84~146 Y-88
#三樓 左X -146~-84  -30~30 84~146 Y-183
#護盾 補血 神盾 連發1 連發2
#1 弓牆槍1盾
#2 盾火雷
#3 盾岩冰
#4 弩群體護盾
#5 火炮補血
#6 維修牆2
#7 黑洞
#8 穿甲
#9 大雜燴
#10 大雜燴

var unlock_unit_table := [
	[0, 1], # 第0關解鎖單位
	[2, 3],	# 第1關
	[4, 5],	# 第2關
	[6, 7],	# 第3關
	[8, 9],	# 第4關
	[10, 11], # 第5關
	[12, 13], # 第6關
	[14], # 第7關
	[15] # 第8關
	# 第9關 無解鎖無輸入
]

func get_unlocked_units() -> Array[int]:
	var unlocked: Array[int] = []  # 初始化為空陣列
	for i in range(currentLevelGS + 1):  # 根據 currentLevelGS 獲取解鎖單位
		if i < unlock_unit_table.size():
			unlocked.append_array(unlock_unit_table[i])  # 平坦化並加入
	#print("unlocked:", unlocked)  # 調試輸出
	return unlocked


var unlock_module_cost_table := [
	1,   # 第1關：初始 模組cost 上限
	1,   # 第2關
	2,   # 第3關
	2,    # 第4關
	3,    # 第5關
	3,    # 第6關
	4,    # 第7關
	4,    # 第8關
	5,    # 第9關
	5,    # 第10關
]
func get_unlock_module_cost() -> int:
	if currentLevelGS < unlock_module_cost_table.size():
		return unlock_module_cost_table[currentLevelGS]
	else:
		push_error("取得unlock_module_cost失敗！")
		return 0  # 或預設值

var unlock_module_type_table := [
	0,   # 第1關：初始模組
	1,   # 第2關
	2,   # 第3關
	2,    # 第4關
	3,    # 第5關
	3,    # 第6關
	4,    # 第7關
	4,    # 第8關
	5,    # 第9關
	5,    # 第10關
]
func get_unlock_module_type() -> int:
	if currentLevelGS < unlock_module_type_table.size():
		return unlock_module_type_table[currentLevelGS]
	else:
		push_error("取得unlock_module_type失敗！")
		return 0  # 或預設值

 

func unlockNewLevel():
	if selectLevelGS != currentLevelGS:
		print("不是最新關卡 不解鎖下一關 ")
		return
	#解鎖新關卡
	if currentLevelGS < 9:
		print("目前關卡：", currentLevelGS , "解鎖新關卡：", currentLevelGS + 1)
		currentLevelGS+=1
		gameData.currentStage = currentLevelGS  # 更新遊戲數據中的階段
		selectLevelGS = currentLevelGS
	saveGameData()
	pass

func _init():
	Engine.time_scale = 1.0 # 確保遊戲速度正常
	loadGameData()  # 嘗試讀取遊戲數據
	pass
		
func _ready():
	#gameData = GameData.new()
	pass
	
func _newGameInit():
	#初始化玩家資料
	gameData = GameData.new()  # 自動調用建構子
	#解鎖遊戲階段 

	
func saveGameData() -> void:
	var save_path := "user://player/gamedata.json"
	DirAccess.make_dir_recursive_absolute("user://player")  # 只建立資料夾

	var data : Dictionary = {
		"currentStage": gameData.currentStage
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_error("無法開啟存檔路徑：" + save_path)
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	print("Gamedata 已儲存：", save_path)


func loadGameData() -> void:
	var save_path := "user://player/gamedata.json"
	if not FileAccess.file_exists(save_path):
		print("找不到存檔，無法讀取 GameData")
		return

	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var loaded = JSON.parse_string(content)
	if typeof(loaded) == TYPE_DICTIONARY:
		var dict: Dictionary = loaded
		if dict.has("currentStage"):
			gameData.currentStage = int(dict["currentStage"])
			currentLevelGS = gameData.currentStage
			print("GameData 讀取成功，目前關卡：", gameData.currentStage)
		else:
			gameData.currentStage = 0
			currentLevelGS = 0
			print("GameData 無 currentStage，預設為 0")
	else:
		print("GameData 讀取失敗，格式錯誤")

func deleteGameData() -> void:
	var save_path := "user://player/gamedata.json"
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		print("GameData 已刪除")
	else:
		print("找不到 GameData 檔案，無法刪除")
