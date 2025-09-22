extends Camera2D

@export var moveSpeed: float = 400
@export var zoomSpeed: float = 10  # 縮放速度
@export var dragSpeed: float = 0.5  # 縮放速度
@export var maxZoom: Vector2 = Vector2(8, 8)  # 最大縮放
@export var minZoom: Vector2 = Vector2(1,1)  # 最小縮放

@export var min_pos: Vector2 = Vector2(-100, -200)
@export var max_pos: Vector2 = Vector2(1500, 800)

var onDrag = false
var lastMousePosition = Vector2.ZERO

# 新增變數來存儲縮放
var newZoom: Vector2

func _ready():
	# 初始化攝影機
	newZoom = zoom

func _process(delta):
	cameraInOut(delta)
	cameraMove(delta)
	#cameraDrag()
	
func cameraInOut(delta):
	# 攝影機縮放控制
	if Input.is_action_just_pressed("camera_ZoomIn"):
		newZoom *= 1.2

	if Input.is_action_just_pressed("camera_ZoomOut"):
		newZoom *= 0.8
		
	newZoom.x = clamp(newZoom.x, minZoom.x, maxZoom.x)
	newZoom.y = clamp(newZoom.y, minZoom.y, maxZoom.y)
	
	zoom = zoom.lerp(newZoom, zoomSpeed * delta)

func cameraMove(delta):
	# 攝影機移動控制
	var newV2 = Vector2.ZERO
	if Input.is_action_pressed("camera_MoveUp"):
		newV2.y -= moveSpeed 
	if Input.is_action_pressed("camera_MoveDown"):
		newV2.y += moveSpeed
	if Input.is_action_pressed("camera_MoveLeft"):
		newV2.x -= moveSpeed
	if Input.is_action_pressed("camera_MoveRight"):
		newV2.x += moveSpeed
	position += newV2 * delta
	position = position.clamp(min_pos, max_pos) # 加上這行

	
func cameraDrag():
	# 滑鼠中鍵拖曳控制
	if Input.is_action_pressed("camera_Translate"):
		if not onDrag:
			onDrag = true
			lastMousePosition = get_global_mouse_position()

		# 計算鼠標移動的距離
		var delta_move = get_global_mouse_position() - lastMousePosition
		position -= delta_move * dragSpeed  # 根據鼠標移動計算位置，並縮小移動速度

		# 更新最後的鼠標位置
		lastMousePosition = get_global_mouse_position()

	elif onDrag:
		onDrag = false
