extends Node

class_name GameData

@export var currentStage : int = 0  # 遊戲當前階段

func _init():
	currentStage = 0  # 初始化當前階段