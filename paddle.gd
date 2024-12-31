extends CharacterBody2D

const SPEED = 400.0

func _physics_process(delta):
    # 获取输入
    var direction = Input.get_axis("ui_left", "ui_right")
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    # 限制球拍在屏幕范围内
    var viewport_rect = get_viewport_rect().size
    position.x = clamp(position.x, 50, viewport_rect.x - 50)
    
    move_and_slide() 