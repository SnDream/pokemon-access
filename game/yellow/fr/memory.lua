CORE_FILES = {"rby"}

RAM_SCREEN = 0x8800
RAM_SAVED_BANK = 0xcf0d
RAM_IN_BATTLE = 0xd05b
RAM_PLAYER_NAME = 0xd15c
RAM_RIVAL_NAME = 0xd34e
RAM_BADGES = 0xd35a
RAM_CURRENT_ENEMY_HEALTH = 0xcfea
RAM_TEXT = 0xc3a0
RAM_OVERWORLD_MAP = 0xc6e8
RAM_MAP_HEADER = 0xd36b
RAM_MAP_NUMBER = RAM_MAP_HEADER - 9
RAM_PLAYER_Y = RAM_MAP_HEADER - 6
RAM_PLAYER_X = RAM_MAP_HEADER - 5
RAM_LAST_MAP_OUTDOORS = RAM_MAP_HEADER - 2
RAM_MAP_HEIGHT = RAM_MAP_HEADER + 1
RAM_MAP_WIDTH = RAM_MAP_HEADER + 2
RAM_MAP_CONNECTIONS = RAM_MAP_HEADER+9
RAM_MAP_NORTH_CONNECTION = RAM_MAP_CONNECTIONS+1
RAM_MAP_NORTH_CONNECTION_START_POINTER = RAM_MAP_NORTH_CONNECTION + 3
RAM_MAP_NORTH_CONNECTION_SIZE = RAM_MAP_NORTH_CONNECTION + 5
RAM_MAP_SOUTH_CONNECTION = RAM_MAP_CONNECTIONS+1+(1*11)
RAM_MAP_SOUTH_CONNECTION_START_POINTER = RAM_MAP_SOUTH_CONNECTION + 3
RAM_MAP_SOUTH_CONNECTION_SIZE = RAM_MAP_SOUTH_CONNECTION + 5
RAM_MAP_WEST_CONNECTION = RAM_MAP_CONNECTIONS+1+(2*11)
RAM_MAP_WEST_CONNECTION_START_POINTER = RAM_MAP_WEST_CONNECTION + 3
RAM_MAP_WEST_CONNECTION_SIZE = RAM_MAP_WEST_CONNECTION + 5
RAM_MAP_EAST_CONNECTION = RAM_MAP_CONNECTIONS+1+(3*11)
RAM_MAP_EAST_CONNECTION_START_POINTER = RAM_MAP_EAST_CONNECTION + 3
RAM_MAP_EAST_CONNECTION_SIZE = RAM_MAP_EAST_CONNECTION + 5
RAM_MAP_EVENT_POINTER = RAM_MAP_HEADER+66
RAM_MAP_OBJECTS = 0xc100
RAM_MISSABLE_FLAGS = 0xd5aa
RAM_MISSABLE_OBJECTS = RAM_MISSABLE_FLAGS + 40
RAM_TILESET_HEADER = 0xd52f
RAM_TILESET_BLOCKS = RAM_TILESET_HEADER + 1
RAM_PASSABLE_TILES = RAM_TILESET_HEADER + 5
RAM_GRASS_TILE = RAM_TILESET_HEADER + 10
ROM_FOOTSTEP_FUNCTION = 0x474
ROM_LEDGE_TILES = 0x1a851
ROM_LAND_COLLISION_PAIRS = 0xada
ROM_WATER_COLLISION_PAIRS = ROM_LAND_COLLISION_PAIRS+34
ROM_WATER_TILESETS = 0xe824
ROM_MANSION_CLIFFS = 0x52280
ROM_GENERAL_WARP_TILES = 0xc1c8
ROM_WARP_TILES = 0xc215
ROM_DOOR_TILES = 0x1a7a8
ROM_SPECIAL_WARP_TILES = 0x7080a
RAM_KEYBOARD_POSITION = 0xcc30
RAM_KEYBOARD_END = 0xc4b6
RAM_KEYBOARD_CASE = 0xc4ce
KEYBOARD_UPPER_STRING = "MAJUSCULES"
KEYBOARD_LOWER_STRING = "minuscules"
