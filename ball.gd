extends CharacterBody2D

var speed = 400.0
var direction = Vector2(0.5, -1).normalized()
var started = false
const MIN_ANGLE = 0.25  # 最小反弹角度（弧度）
const MAX_TOP_HITS = 3  # 连续撞击顶部的最大次数
var top_hit_count = 0   # 记录连续撞击顶部的次数
var play_time = 0.0     # 记录游戏时间

func _ready():
	position = Vector2(576, 550)

func _physics_process(delta):
	if !started:
		if Input.is_action_just_pressed("ui_accept"):
			started = true
			play_time = 0.0
		return
	
	play_time += delta
	
	# 随着时间增加下落趋势
	if play_time > 5.0:  # 5秒后开始增加下落趋势
		direction.y += delta * 0.1  # 逐渐增加向下的分量
		direction = direction.normalized()
	
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var normal = collision.get_normal()
		direction = direction.bounce(normal)
		
		# 处理顶部碰撞
		if normal.y < -0.9:  # 检测是否撞到顶部
			top_hit_count += 1
			if top_hit_count >= MAX_TOP_HITS:
				# 强制调整反弹角度
				var random_x = randf_range(-0.8, 0.8)
				direction = Vector2(random_x, 0.6).normalized()
				top_hit_count = 0
		else:
			top_hit_count = 0
		
		# 确保反弹角度不会太小
		var angle = abs(atan2(direction.y, direction.x))
		if angle < MIN_ANGLE or angle > PI - MIN_ANGLE:
			var sign_x = sign(direction.x)
			var sign_y = sign(direction.y)
			direction.x = sign_x * cos(MIN_ANGLE)
			direction.y = sign_y * sin(MIN_ANGLE)
			direction = direction.normalized()
		
		if collision.get_collider().name == "Paddle":
			var paddle = collision.get_collider()
			var hit_pos = position.x - paddle.position.x
			var paddle_width = 100
			var factor = hit_pos / (paddle_width / 2)
			factor = clamp(factor, -0.8, 0.8)
			direction = Vector2(factor, -1).normalized()
			top_hit_count = 0  # 击中球拍时重置顶部撞击计数
		elif collision.get_collider().is_in_group("brick"):
			collision.get_collider().destroy()
			speed = min(speed + 10, 600)
			top_hit_count = 0  # 击中砖块时重置顶部撞击计数
	
	# 检查是否掉出屏幕底部
	if position.y > 700:
		var parent = get_parent()
		print("球掉出屏幕，Y位置：", position.y)
		if parent.has_method("game_over"):
			print("调用游戏结束")
			parent.game_over()
		else:
			print("未找到game_over方法，执行重置")
			reset_ball()
	
	# 确保球不会卡在边界
	var viewport_rect = get_viewport_rect().size
	position.x = clamp(position.x, 0, viewport_rect.x)
	position.y = clamp(position.y, 0, viewport_rect.y)

func reset_ball():
	position = Vector2(576, 550)
	direction = Vector2(0.5, -1).normalized()
	started = false
	speed = 400.0
	play_time = 0.0
	top_hit_count = 0 
