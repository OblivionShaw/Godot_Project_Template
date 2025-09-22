extends Node2D

#附加到Node將整個Scene放入Autoload
	
#@export var weapon_bullet: ResourceData
#@export var weapon_bullet: Array[ResourceData] = []
@export var resData: Array = []

# 根據索引獲取資源
func get_resData(index: int) -> ResourceData:
	return resData[index]

# 根據名稱查找資源（假設 ResourceData 中有一個 resource_name 屬性）
func find_resData_by_name(name: String) -> ResourceData:
	for res in resData:
		if res.resDataName == name:
			return res
	return null

# 新增：依 key 取得
func find_resData_by_key(key_to_find: int)-> ResourceData:
	for res in resData:
		# 先確認型別，再比對 key
		#print ("查找資源，key:", key_to_find, "當前資源key:", res.key)
		if res is ResourceData and res.key == key_to_find:
			return res
	printerr("找不到指定的資源，key:", key_to_find)
	return null	
