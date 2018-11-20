// Memory Addresses for player location
player 1 x-coordinate = 0000 1111 0000 1111
player 1 y-coordinate = 0000 1111 0000 1110
player 2 x-coordinate = 0000 1111 0000 1101
player 2 y-coordinate = 0000 1111 0000 1100

// Player health addresses
player 1 health = 0000 1110 0111 0100
player 2 health = 0000 1110 0111 0011

// Orientation addresses. Orientation: 00 = UP, 01 = RIGHT, 10 = DOWN, 11 = LEFT
player 1 orientation = 0000 1110 0111 0010
player 2 orientation = 0000 1110 0111 0001
projectile 1 orientation = 0000 1110 0111 0000
projectile 2 orientation = 0000 1110 0110 1111

// Memory addresses for projectiles 15 is the valid bit and 0-14 is position
projectile 1 x-coordinate = 0000 1111 0000 1011
projectile 1 y-coordinate = 0000 1111 0000 1010
projectile 2 x-coordinate = 0000 1111 0000 1001
projectile 2 y-coordinate = 0000 1111 0000 1000

// Game state address, will tell the vga fsm whether to draw the start screen or the game screen
// if the value at this address is 0 then draw the start menu if its anything else draw the game screen
game state = 0000 1111 0000 0111

// Stack region of memory
top of stack = 0000 1111 0000 0100
bottom of stack = 0000 1110 1111 0000

// this will hold the coordinates of the walls in the map so we can do collision detection
// since the coordinates don't need to be too big we will pack x coord and y coord in 16 bits
end of wall coordinates = 0000 1110 1110 1111
start of wall coordinates = 0000 1110 1101 1100

// Register conventions
REG0 - REG4 // temporary register
REG5 - REG10 // saved register
REG11 // Return register
REG12 // Stack pointer
REG13 // Jump target register
REG14 // arg1
REG15 // arg2