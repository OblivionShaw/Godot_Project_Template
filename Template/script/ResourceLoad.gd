extends Node

func _loadRes(path):
	var dir = DirAccess.open(path)
	var resData = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# 確保是檔案且副檔名為 .tres
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var resource = load(path + file_name)
				if resource is AudioData:  # 確保加載的資源是 AudioData 類型
					resData.append(resource)
			file_name = dir.get_next()
		
		dir.list_dir_end()
					
	print("已指定資源數量:", resData.size())
	return resData
	
func _loadDict(path: String) -> Dictionary:
	var dir = DirAccess.open(path)
	var resData = {}  # 使用字典來分類資源
	resData["audio"] = []  # 儲存音效的 Array
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# 確保是檔案且副檔名為 .tres
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var resource = load(path + file_name)
				if resource is AudioData:  # 如果是 AudioData 類型的資源
					resData["audio"].append(resource)  # 加入音效資源
			file_name = dir.get_next()
		
		dir.list_dir_end()
				
	print("已指定音效資源數量:", resData["audio"].size())
	return resData  # 返回包含分類資源的字典
	
