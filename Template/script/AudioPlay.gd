extends Node

func _playByName(name : String):
	AudioManager.playByName(name)
	
func _playByIndex(index : int):
	AudioManager.playByIndex(index)