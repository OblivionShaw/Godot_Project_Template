extends Node2D

#播放音效後自動queue_free回收

func play():
	print("playyy")
	pass
		
func _on_finished():
	queue_free()
	pass # Replace with function body.
