extends Node

var player1_status: bool = true
var player2_status: bool = true
var player3_status: bool = true

var curr_player1_speed: int
var curr_player2_speed: int
var curr_player3_speed: int

var enemy1_status: bool = true
var enemy2_status: bool = true

var curr_enemy1_speed: int
var curr_enemy2_speed: int

var playerTurn = 1
var partySize = 1

var paused = 0

var enemyTarget = 0
