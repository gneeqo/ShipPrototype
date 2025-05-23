class_name referee extends Node

@export var ship_types : Array[PackedScene]
@export var Camera : ShipTrackingCamera
@export var enemy_types : Array[PackedScene]
@export var fence_scene : PackedScene

@export var boss:BossEnemy 

@export var num_enemies : int

@export var BorderSize : float
@export var hud:Hud

@export var Boss:PackedScene

@export var BossTimer:float
var bossSpawned = false

var player_ship: Ship
var player_ship_type: int = 0


var enemy_timer: float = 0

var numEnemies:int = 0

func _ready():
    spawn_ship()
    spread_enemies(num_enemies)
    place_borders()



func place_borders():
    var x = -BorderSize
    while x <= BorderSize:
        var new_border:Node2D = fence_scene.instantiate()
        new_border.global_position = Vector2(x,-BorderSize)
        var border_sprite : Sprite2D = new_border.get_child(0)
        x += border_sprite.texture.get_height()
        new_border.global_rotation_degrees = 90
        get_parent().add_child.call_deferred(new_border)
        
    
    x = -BorderSize
    while x <= BorderSize:
        var new_border:Node2D = fence_scene.instantiate()
        new_border.global_position = Vector2(x,BorderSize)
        var border_sprite : Sprite2D = new_border.get_child(0)
        x += border_sprite.texture.get_height()
        new_border.global_rotation_degrees = 90
        get_parent().add_child.call_deferred(new_border)
    
    var y = -BorderSize
    while y <= BorderSize:
        var new_border:Node2D = fence_scene.instantiate()
        new_border.global_position = Vector2(BorderSize,y)
        var border_sprite : Sprite2D = new_border.get_child(0)
        y += border_sprite.texture.get_height()
        get_parent().add_child.call_deferred(new_border)
        
    y = -BorderSize
    while y <= BorderSize:
        var new_border:Node2D = fence_scene.instantiate()
        new_border.global_position = Vector2(-BorderSize,y)
        var border_sprite : Sprite2D = new_border.get_child(0)
        y += border_sprite.texture.get_height()
        get_parent().add_child.call_deferred(new_border)
        
func spread_enemies(amount_to_spread:int):
    var random = RandomNumberGenerator.new()
    
    if amount_to_spread > 1: 
        hud.AddToSmallTextQueue(str(amount_to_spread)+" enemies spawned")
    else:
        hud.AddToSmallTextQueue("1 enemy spawned")
    for i in amount_to_spread:
        var rand_x = random.randi_range(-BorderSize,BorderSize)
        var rand_y = random.randi_range(-BorderSize,BorderSize)
        
        spawn_enemy(enemy_types.pick_random(),Vector2(rand_x,rand_y))
        
        
    
    
        
func enemy_killed():
    numEnemies-=1
    hud.setNumEnemies(numEnemies)

func spawn_enemy(enemy:PackedScene,location:Vector2):
    var new_enemy : BaseEnemy = enemy.instantiate()
    new_enemy.global_position = location
    get_parent().add_child.call_deferred(new_enemy)
    numEnemies+=1
    hud.setNumEnemies(numEnemies)
    
func spawn_boss():
    var random = RandomNumberGenerator.new()
    
    var rand_x = random.randi_range(-BorderSize/4,BorderSize/4)
    var rand_y = random.randi_range(-BorderSize/4,BorderSize/4)
        
    var new_enemy : BossEnemy = Boss.instantiate()
    new_enemy.global_position = Vector2(rand_x,rand_y)
    get_parent().add_child.call_deferred(new_enemy)
    
    
    hud.PostBigText("Boss Spawned", 3)
    
    

func spawn_ship():
    if not is_instance_valid(player_ship):
        player_ship = ship_types[player_ship_type].instantiate()
        get_parent().add_child.call_deferred(player_ship)
        Camera.ship = player_ship
    
    
func destroy_ship():
    if is_instance_valid(player_ship):
        player_ship.kill()

func _process(dt:float):
    if Input.is_action_just_pressed("switch_ship_1"):
        switch_ship(0)
    elif Input.is_action_just_pressed("switch_ship_2"):
        
        switch_ship(1)
        
    elif Input.is_action_just_pressed("switch_ship_3"):
        
        switch_ship(2)
        
        
    enemy_timer +=dt
    
    if enemy_timer >= 20:
        enemy_timer = 0
       
        spread_enemies(15)

    BossTimer-=dt
    if BossTimer <=0 and not bossSpawned:
        bossSpawned = true
        spawn_boss()


func ship_killed():
    destroy_ship()
    var newSpawn = Callable(self,"spawn_ship")
    add_child(BehaviorFactory.delayed_callback(newSpawn,5.0))
    
func switch_ship(new_type:int):
    destroy_ship()
    player_ship_type = new_type
    hud.PostBigText("Switched to type " + str(new_type),1)
    var newSpawn = Callable(self,"spawn_ship")
    add_child(BehaviorFactory.delayed_callback(newSpawn,5.0))  
