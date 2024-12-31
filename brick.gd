extends StaticBody2D

signal brick_destroyed(score_value)

var score_value = 1  # 默认分值为1

func _ready():
    # 设置碰撞层，确保球可以与砖块碰撞
    collision_layer = 1
    collision_mask = 2

func set_score_value(value):
    score_value = value

func destroy():
    emit_signal("brick_destroyed", score_value)
    queue_free() 