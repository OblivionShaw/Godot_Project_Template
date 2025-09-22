extends Resource

class_name ResourceData
@export var key: int
var resDataScene: PackedScene
@export var ResDataScene: PackedScene:
	get:
		return resDataScene
	set(value):
		resDataScene = value

@export var resDataName: String

func attack():
	pass
