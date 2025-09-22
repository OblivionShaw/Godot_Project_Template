extends Node

func _textLocalizationSelf(key , path) -> void:
	pass

func _textLocalization(key , path) -> void:
	var target = get_node(path)
	target.text = key
	
func _textSPLocalization(key, path , type):
	match type:
		0:
			TranslationServer.set_locale("TW")
		1:
			TranslationServer.set_locale("en")
		2:
			TranslationServer.set_locale("ja")
		3:
			TranslationServer.set_locale("CN")
	pass
	
func _tooltipLocalization(value: String) -> void:
	self.tooltip_text = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_options_button_down(extra_arg_0: String, extra_arg_1: NodePath) -> void:
	pass # Replace with function body.
