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

// Memory addresses for projectiles coordinates. If the value at these addresses are
// all zeros then they are not valid, don't draw them. If they are anything else, draw
// them at the coordinate values
projectile 1 x-coordinate = 0000 1111 0000 1011
projectile 1 y-coordinate = 0000 1111 0000 1010
projectile 2 x-coordinate = 0000 1111 0000 1001
projectile 2 y-coordinate = 0000 1111 0000 1000

// Game state address, will tell the vga fsm whether to draw the start screen, game screen, or game over screen
// if the value at this address is 00 then draw the start menu if its 01 then draw the game screen, if its 10
// then draw game over player 1 wins, if its 11 the draw game over player 2 wins.
game state = 0000 1111 0000 0111

// Stack region of memory
top of stack = 0000 1111 0000 0100
bottom of stack = 0000 1110 1111 0000

// this will hold the bitmap of the walls in the map so we can do collision detection
end of wall coordinates = 0001 0001 0001 1011
start of wall coordinates = 0000 1111 1111 0000

// Register conventions
REG0 - REG4 // temporary register
REG5 - REG10 // saved register
REG11 // Return register
REG12 // Stack pointer
REG13 // Jump target register
REG14 // arg1
REG15 // arg2
