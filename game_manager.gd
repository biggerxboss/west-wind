extends Node2D

@onready var ball = $Ball
@onready var brick_manager = $BrickManager
@onready var game_over_ui = $GameOverUI
@onready var final_score_label = $GameOverUI/FinalScore
@onready var restart_button = $GameOverUI/RestartButton

func _ready():
    print("游戏管理器初始化")  # 调试信息
    # 检查所有必需节点
    if not ball:
        push_error("找不到球节点")
    if not brick_manager:
        push_error("找不到砖块管理器节点")
    if not game_over_ui:
        push_error("找不到游戏结束UI节点")
    if not final_score_label:
        push_error("找不到最终分数标签节点")
    if not restart_button:
        push_error("找不到重新开始按钮节点")
    
    if ball and brick_manager and game_over_ui and final_score_label and restart_button:
        restart_button.pressed.connect(_on_restart_button_pressed)
        print("所有节点初始化成功")  # 调试信息
    
func game_over():
    print("游戏结束函数被调用")  # 调试信息
    if not is_instance_valid(game_over_ui):
        push_error("游戏结束UI无效")
        return
    if not is_instance_valid(brick_manager):
        push_error("砖块管理器无效")
        return
    if not is_instance_valid(ball):
        push_error("球无效")
        return
    
    game_over_ui.visible = true
    final_score_label.text = "最终得分: %d" % brick_manager.score
    ball.set_physics_process(false)
    print("游戏结束UI已显示")  # 调试信息

func _on_restart_button_pressed():
    print("重新开始按钮被点击")  # 调试信息
    if not is_instance_valid(game_over_ui):
        push_error("游戏结束UI无效")
        return
    if not is_instance_valid(brick_manager):
        push_error("砖块管理器无效")
        return
    if not is_instance_valid(ball):
        push_error("球无效")
        return
    
    game_over_ui.visible = false
    brick_manager.reset_game()
    ball.reset_ball()
    ball.set_physics_process(true)
    print("游戏已重新开始")  # 调试信息 