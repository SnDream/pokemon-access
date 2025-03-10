CORE_FILES = {"gsc", "crystal_cn"}

RAM_SCREEN = 0x8800
RAM_IN_BATTLE = 0xd22d
RAM_TEXT = 0xc4a0
RAM_ATTR = 0xcdd9
RAM_CURRENT_ENEMY_HEALTH = 0xd216
RAM_OVERWORLD_MAP = 0xc800
RAM_PLAYER_NAME = 0xd47d
RAM_MOM_NAME = 0xd488
RAM_RIVAL_NAME = 0xd493
RAM_RED_NAME = 0xd49e
RAM_GREEN_NAME = 0xd4a9
RAM_BADGES = 0xd857
RAM_MAP_GROUP = 0xdcb5
RAM_MAP_NUMBER = 0xdcb6
RAM_PLAYER_Y = 0xdcb7
RAM_PLAYER_X = 0xdcb8
RAM_MAP_HEADER = 0xd19d
RAM_MAP_HEIGHT = RAM_MAP_HEADER + 1
RAM_MAP_WIDTH = RAM_MAP_HEADER + 2
RAM_MAP_SCRIPT_HEADER_BANK = RAM_MAP_HEADER+6
RAM_MAP_EVENT_HEADER_POINTER = RAM_MAP_HEADER+9
RAM_MAP_CONNECTIONS = RAM_MAP_HEADER+11
RAM_MAP_NORTH_CONNECTION = RAM_MAP_CONNECTIONS+1
RAM_MAP_NORTH_CONNECTION_START_POINTER = RAM_MAP_NORTH_CONNECTION + 4
RAM_MAP_NORTH_CONNECTION_SIZE = RAM_MAP_NORTH_CONNECTION + 6
RAM_MAP_SOUTH_CONNECTION = RAM_MAP_CONNECTIONS+1+(1*12)
RAM_MAP_SOUTH_CONNECTION_START_POINTER = RAM_MAP_SOUTH_CONNECTION + 4
RAM_MAP_SOUTH_CONNECTION_SIZE = RAM_MAP_SOUTH_CONNECTION + 6
RAM_MAP_WEST_CONNECTION = RAM_MAP_CONNECTIONS+1+(2*12)
RAM_MAP_WEST_CONNECTION_START_POINTER = RAM_MAP_WEST_CONNECTION + 4
RAM_MAP_WEST_CONNECTION_SIZE = RAM_MAP_WEST_CONNECTION + 6
RAM_MAP_EAST_CONNECTION = RAM_MAP_CONNECTIONS+1+(3*12)
RAM_MAP_EAST_CONNECTION_START_POINTER = RAM_MAP_EAST_CONNECTION + 4
RAM_MAP_EAST_CONNECTION_SIZE = RAM_MAP_EAST_CONNECTION + 6
RAM_MAP_OBJECTS = 0xd71e
RAM_LIVE_OBJECTS = RAM_MAP_OBJECTS+0x100
RAM_COLLISION_BANK = 0xd1df
RAM_COLLISION_ADDR = 0xd1e0
RAM_OBJECT_STRUCTS = 0xd4fe
RAM_KEYBOARD_X = 0xc330
RAM_KEYBOARD_Y = 0xc331
RAM_UNOWN_PUZZLE = 0xc6d0
RAM_PUZZLE_CURSOR = 0xcf65
ROM_FOOTSTEP_FUNCTION = 0xd4cd
ROM_TILE_FLAGS = 0x4ce1f
KEYBOARD_STRING = "DEL   END"
KEYBOARD_UPPER = {
{"A", "B", "C", "D", "E", "F", "G", "H", "I"},
{"J", "K", "L", "M", "N", "O", "P", "Q", "R"},
{"S", "T", "U", "V", "W", "X", "Y", "Z", "SPACE"},
{"-", "?", "!", "/", ".", ",", "SPACE", "SPACE", "SPACE"},
{"lower", "lower", "lower", "DEL", "DEL", "DEL", "END", "END", "END"}
}

KEYBOARD_LOWER = {
{"a", "b", "c", "d", "e", "f", "g", "h", "i"},
{"j", "k", "l", "m", "n", "o", "p", "q", "r"},
{"s", "t", "u", "v", "w", "x", "y", "z", "space"},
{"×", "(", ")", ":", ";", "[", "]", "PK", "MN"},
{"UPPER", "UPPER", "UPPER", "DEL", "DEL", "DEL", "END", "END", "END"}
}
KEYBOARD_UPPER_STRING = "UPPER"


