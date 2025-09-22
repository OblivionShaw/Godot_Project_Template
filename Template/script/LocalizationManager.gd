extends Node

#https://docs.godotengine.org/en/3.2/tutorials/i18n/locales.html

# 儲存語言顯示名稱和對應語言代碼的字典
var locale_dict = {
	"Loc_繁體中文": "zh_TW",  # 繁體中文 (台灣)
	"Loc_日文": "ja_JP",  # 日文
	"Loc_英文": "en_US",  # 英文 (美國)
	"Loc_簡體中文": "zh_CN",  # 簡體中文 (中國)
	"Loc_俄語": "ru_RU", 
	"Loc_西班牙語(西班牙)": "es_ES", 
	"Loc_葡萄牙語(巴西)": "pt_BR",
	"Loc_德語": "de_DE",
	"Loc_法語": "fr_FR",
	"Loc_韓語": "ko_KR",
	"Loc_波蘭語": "pl_PL",
	"Loc_土耳其語": "tr_TR",
	"Loc_泰語": "th_TH",
	"Loc_烏克蘭語": "uk_UA",
	"Loc_義大利語": "it_IT",
	"Loc_捷克語": "cs_CZ",
	"Loc_西班牙語(拉丁美洲)": "es_419",
	"Loc_匈牙利語": "hu_HU",
	"Loc_葡萄牙語(葡萄牙)": "pt_PT",

	# 俄文ru_RU
	# 西班牙語(西班牙)es_ES
	# 葡萄牙語(巴西)pt_BR
	# 德文de_DE
	# 法語fr_FR
	# 韓文ko_KR
	# 波蘭語pl_PL
	# 土耳其語tr_TR
	# 泰語th_TH
	# 烏克蘭語uk_UA
	# 義大利語it_IT
	# 捷克語cs_CZ
	# 西班牙語(拉丁美洲)es_ES/es_419  es_MX（墨西哥）、es_AR（阿根廷）、es_CL（智利）
	# 匈牙利語hu_HU
	# 葡萄牙語(葡萄牙)pt_PT
	# 其他語言可以在此補充
}

# 設定當前語言的函數
func _set_locale_from_dict(locale_display_name: String):
	if locale_dict.has(locale_display_name):
		var target_locale = locale_dict[locale_display_name]
		TranslationServer.set_locale(target_locale)  # 設定語言
		print("多國語言設定:", target_locale)
	else:
		print("多國語言找不到:", locale_display_name)
		
# 設定語言
func _set_locale_from_locCode(value):
	TranslationServer.set_locale(value)
	

# 返回所有語言對應字典的函數
func _get_all_locales() -> Dictionary:
	return locale_dict
	
# 根據 OS.get_locale() 檢查語言代碼 沒有就預設英文
func _defaultLocale() -> String:
	var current_locale = OS.get_locale()  # 取得當前系統語言代碼
	
	# 檢查字典中是否有對應的語言代碼
	for locale_name in locale_dict.values():
		if locale_name == current_locale:
			return current_locale  # 如果有，返回當前語言代碼
	
	# 如果沒有，回傳預設語言代碼 "en_US"
	return "en_US"

# 範例：呼叫這些函數
func _ready():
	pass
	# 取得所有語言的資料
	#var all_locales = _get_all_locales()
	#print("All locales: ", all_locales)
	
	# 假設從設定頁面選擇了"Loc_繁體中文"這個選項，並設置為繁體中文
	#_set_locale_from_dict("Loc_繁體中文")
