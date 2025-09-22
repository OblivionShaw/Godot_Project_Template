extends Resource

class_name AudioData
@export var key: int
@export var audioDataName: String

var audio: AudioStream
@export var getAudio: AudioStream:
	get:
		return audio
	set(value):
		audio = value
		
func Play():
	getAudio.instantiate()
	pass
