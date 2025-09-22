extends Node

#自動翻譯string合併無須翻譯string替換text

func _ready():
	update_localized_text()

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_localized_text()

# 更新本地化的文字
func update_localized_text():
	# 判斷是否是 Button 或 Label
	if is_instance_valid(self) and (self.is_class("Button") or self.is_class("Label")):
		var original_text = self.text
		var translated_text = ""
		var start_index = 0
		
		while start_index < original_text.length():
			# 找到 Loc_ 開頭的詞
			var loc_start = original_text.find("Loc_", start_index)
			if loc_start == -1:
				# 如果沒有找到 Loc_，則將剩餘部分添加到 translated_text 並退出循環
				translated_text += original_text.substr(start_index, original_text.length() - start_index)
				break
			
			# 將 Loc_ 前的部分添加到 translated_text
			translated_text += original_text.substr(start_index, loc_start - start_index)
			
			# 找到結尾的分隔符 "
			var loc_end = original_text.find('"', loc_start)
			if loc_end == -1:
				# 如果沒有找到結尾的 "，則將剩餘部分添加到 translated_text 並退出循環
				translated_text += original_text.substr(loc_start, original_text.length() - loc_start)
				break
			
			# 獲取需要翻譯的詞，去除結尾的 "
			var word_to_translate = original_text.substr(loc_start, loc_end - loc_start)
			
			# 打印出需要翻譯的詞
			print("Translating key: " + word_to_translate)
			
			var translated_word = TranslationServer.translate(word_to_translate)
			
			# 將翻譯後的詞添加到 translated_text
			translated_text += translated_word
			
			# 移動 start_index 到下一個位置
			start_index = loc_end + 1

		# 更新 text 屬性
		self.text = translated_text