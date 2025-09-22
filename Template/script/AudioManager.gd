extends Node2D

#附加到Node將整個Scene放入Autoload

@export_category("BGM")
# 儲存BGM播放器
@export var bgm_player: AudioStreamPlayer2D
@export var bgmlist : Array[AudioStream]

@export_category("SP")
@export var sfxPlayer: AudioStreamPlayer2D

@export_category("SFX")
@export var audioPlay:PackedScene
var audioStream:AudioStreamPlayer2D
@export var audioData: Array[AudioData] = []

#click Modern 1
#confirm Modern 8
#cancel Modern 9
#sptips retro7
#unlock Minimalist13
#recycle WoodBlock1
#build Coffee/African 2
#harvest Modern 10


func _ready() -> void:
	if(audioData.size() == 0):
		loadAudioRes()

	if get_tree().get_current_scene().get_name() == "Menu":
		playBGM(0)
	if get_tree().get_current_scene().get_name() == "Xenoflora":
		#playBGM(1) #註解化 2025/02/03

		#更改播放BGM 2025/02/03
		playBGM(0) 
		#---

	#audioData = ResourceLoad._loadRes("res://Resource/AudioRes/") as Array[AudioData]  # 強制轉型為 Array[AudioData]
	#playBGM(bgmlist[0])
	await get_tree().create_timer(1.0).timeout 
	#playByIndex(0)
	await get_tree().create_timer(1.0).timeout 
	#playSameTimeByName("bow1")
	
#抓取audioData
func loadAudioRes():
	var dir = DirAccess.open("res://resource/audioRes/")
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# 確保是檔案且副檔名為 .tres
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var resource = load("res://resource/audioRes/" + file_name)
				if resource is AudioData:  # 確保加載的資源是 AudioData 類型
					audioData.append(resource)
			file_name = dir.get_next()
		
		dir.list_dir_end()

	print("已載入音效資源數量:", audioData.size())  # 確認載入結果


# 播放BGM
func playBGM(index: int):
	# 確保 index 有值
	if index < 0 or index >= bgmlist.size():
		print("播放BGM錯誤 無此INDEX")
		return
	_stopBGM()  # 停止當前音樂
	bgm_player.stream = bgmlist[index]  # 根據索引選擇對應音樂
	bgm_player.play()  # 播放選中的音樂

# 停止BGM
func _stopBGM():
	bgm_player.stop()
	
#
func playSameTimeByName(name: String):
	# 假設 sfxPlayer 是音效播放的物件
	# 先停止目前正在播放的音效
	sfxPlayer.stop()

	# 取得音效資料
	var audio = find_audioData_by_name(name)
	if audio != null:
		# 設定音效並播放
		sfxPlayer.stream = audio.getAudio
		sfxPlayer.play()
	else:
		print("未找到名為", name, "的音檔")


# 根據index播放音效
func playByIndex(index: int):
	
	audioStream = audioPlay.instantiate()
	var root = get_tree().root
	root.add_child(audioStream)
	audioStream.stream = audioData[index].getAudio
	audioStream.play()
	
	#return audioStream
	
# 根據名稱播放音效
func playByName(name: String):
	var audio = find_audioData_by_name(name)
	if audio != null:
		audioStream = audioPlay.instantiate()
		#var root = get_tree().root
		self.add_child(audioStream)
		audioStream.stream = audio.getAudio
		audioStream.play()
		#audioStream.connect("finished", Callable(audioStream, "queue_free"))
	else:
		print("未找到名為", name, "的音檔")

# 根據名稱查找return音效
func find_audioData_by_name(name: String) -> AudioData:
	for audio in audioData:
		if audio.audioDataName == name:
			#print("yes")
			return audio
	return null
