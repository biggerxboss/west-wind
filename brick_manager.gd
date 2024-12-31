extends Node2D

const BRICK_COLORS = [
    Color(1, 0.4, 0.4),    # 红色 - 4分
    Color(1, 0.8, 0.4),    # 黄色 - 3分
    Color(0.4, 1, 0.4),    # 绿色 - 2分
    Color(0.4, 0.8, 1),    # 蓝色 - 1分
]

var brick_scene = preload("res://brick.tscn")
var score = 0

func _ready():
    create_bricks()

func create_bricks():
    for row in range(4):
        for col in range(10):
            var brick = brick_scene.instantiate()
            add_child(brick)
            
            # 设置砖块位置
            brick.position = Vector2(
                col * 100 + 140,
                row * 40 + 80
            )
            
            # 设置砖块颜色
            var color_rect = brick.get_node("ColorRect")
            color_rect.color = BRICK_COLORS[row]
            
            # 设置分值（从底层到顶层：1,2,3,4分）
            brick.set_score_value(4 - row)
            
            # 连接销毁信号
            brick.brick_destroyed.connect(_on_brick_destroyed)

func _on_brick_destroyed(value):
    score += value
    # 更新UI显示
    var score_label = get_node_or_null("../ScoreLabel")
    if score_label:
        score_label.text = "分数: %d" % score

func reset_game():
    # 清除所有现有的砖块
    for brick in get_children():
        brick.queue_free()
    
    # 重置分数
    score = 0
    var score_label = get_node_or_null("../ScoreLabel")
    if score_label:
        score_label.text = "分数: 0"
    
    # 重新创建砖块
    create_bricks() 