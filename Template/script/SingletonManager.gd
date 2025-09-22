extends Node

@onready var gm: GameManager = get_node("/root/GameManager")
@onready var audio: AudioManager = get_node("/root/AudioManager")
@onready var rm: ResourceManager = get_node("/root/ResourceManager")
@onready var ikm: InputKeyManager = get_node("/root/InputKeyManager")

#LM
#SLM

func get_audio() -> AudioManager:
	#return audio if audio else null
	if not audio:
		print("AudioManager 尚未正確初始化")  # 或 print("AudioManager 尚未初始化")
		return null
	return audio
