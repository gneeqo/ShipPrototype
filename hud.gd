class_name Hud extends Control

@export var BigText:RichTextLabel
@export var SmallText:RichTextLabel
@export var Counter:RichTextLabel




var SmallTextQueue:Array[String]
var isDisplayingSmallText = false


func setNumEnemies(num:int):
    Counter.text = str(num) + " Enemies Remaining"

func _ready():
    BigText.modulate.a = 0
    SmallText.modulate.a = 0

func PostBigText(text:String, duration:float):
    BigText.text = text
    
    var textBehavior = BehaviorFactory.fade(1,duration,true)
    BehaviorFactory.add_action_to_behavior(ActionFactory.fade(0,duration,true,Action.EaseType.easeInOutSine,true),textBehavior)
    BigText.add_child(textBehavior)
    

func PostSmallText(text:String, duration:float):
    SmallText.text = text
    
    var textBehavior = BehaviorFactory.fade(1,duration,true)
    BehaviorFactory.add_action_to_behavior(ActionFactory.fade(0,duration,true,Action.EaseType.easeInOutSine,true),textBehavior)
    BehaviorFactory.add_callback_to_behavior(Callable(self,"SmallTextDoneDisplaying"),textBehavior)
    SmallText.add_child(textBehavior)
    
func DisplayNextSmallTextQueue():
    PostSmallText(SmallTextQueue.pop_front(),0.8)
    isDisplayingSmallText = true

func SmallTextDoneDisplaying():
    if SmallTextQueue.size() >0:
        DisplayNextSmallTextQueue()
    else:
        isDisplayingSmallText = false
    
    
func AddToSmallTextQueue(text:String):
    SmallTextQueue.push_back(text)
    if not isDisplayingSmallText:
        DisplayNextSmallTextQueue()
