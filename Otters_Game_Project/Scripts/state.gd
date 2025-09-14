extends Node

var pos1Char : String = "Peepo"
var pos2Char : String = "empty"
var pos3Char : String = "empty"

var P1_current_health = 50
var P1_max_health = 50
var P1_damage = 20

var P2_current_health = 50
var P2_max_health = 50
var P2_damage = 20

var P3_current_health = 50
var P3_max_health = 50
var P3_damage = 20

var enemy_type1 = null
var enemy_type2 = null


var enemy1:Resource
var enemy2:Resource

var defeated_enemy
var defeated_enemies = []

var playerx = null
var playery = null

func save_position(x, y):
	playerx = x
	playery = y


func remove_enemy():
	defeated_enemies.insert(0, defeated_enemy)

func load_enemy():
	enemy1 = load("res://Characters/"+enemy_type1+".tres")
	
	if  enemy_type2 != "null":
		enemy2 = load("res://Characters/"+enemy_type2+".tres")
