// Memory Addresses for player orientation and location Orientation is the upper two bits and location is the lower 14 bit
loc1x = 0000 1111 0000 1111 // Location for player one x coordinate
loc1y = 0000 1111 0000 1110 // Location for player one y coordinate
loc2x = 0000 1111 0000 1101 // Location for player one x coordinate
loc2y = 0000 1111 0000 1100 // Location for player one y coordinate

// Orientation: 00 = UP, 01 = RIGHT, 10 = DOWN, 11 = LEFT 

// Memory addresses for projectiles 15 is the valid bit, 13-14 is orientation/direction and 0-12 is position
proj1x = 0000 1111 0000 1011 // Location for projectile one x coordinate
proj1y = 0000 1111 0000 1010 // Location for projectile one y coordinate
proj2x = 0000 1111 0000 1001 // Location for projectile two x coordinate
proj2y = 0000 1111 0000 1000 // Location for projectile two y coordinate

// Game state address, will tell the vga fsm whether to draw the start screen or the game screen
// if the value at this address is 0 then draw the start menu if its anything else draw the game screen
game_state = 0000 1111 0000 0111

// Health of players address
health1 = 0000 1111 0000 0110
health2 = 0000 1111 0000 0101

// Stack region of memory
top_of_stack = 0000 1111 0000 0100
bottom_of_stack = 0000 1110 1111 0000

// this will hold the coordinates of the walls in the map so we can do collision detection
// since the coordinates don't need to be too big we will pack x coord and y coord in 16 bits
end_of_wall_coordinates = 0000 1110 1110 1111
start_of_wall_coordinates = 0000 1110 1101 1100

// Register conventions
REG0 - REG4 // temporary register
REG5 - REG10 // saved register
REG11 // Return register
REG12 // Stack pointer
REG13 // Jump target register
REG14 // arg1
REG15 // arg2
