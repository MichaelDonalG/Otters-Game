extends Node

var pos1Char : String = "Peepo"
var pos2Char : String = "empty"
var pos3Char : String = "empty"

var player1_speed: int = 10
var player2_speed: int = 7
var player3_speed: int = 8

var enemy_type1 = null
var enemy_type2 = null

var enemy1:Resource = null
var enemy2:Resource = null

var defeated_enemy
var defeated_enemies = []

var playerx = null
var playery = null

func save_position(x, y):
	playerx = x
	playery = y


func remove_enemy():
	defeated_enemies.insert(0, defeated_enemy)

func reset():
	enemy_type1 = null
	enemy_type2 = null
	
	enemy1 = null
	enemy2 = null

func load_enemy():
	enemy1 = load("res://Enemies/"+enemy_type1+".tres")
	
	if  enemy_type2 != "null":
		enemy2 = load("res://Enemies/"+enemy_type2+".tres")

func set_stats():
	match pos1Char:
		pass
	match pos2Char:
		pass
	match pos3Char:
		pass
