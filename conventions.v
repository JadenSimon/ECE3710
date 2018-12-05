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
top of stack = 1111 0000 0000 0000
bottom of stack = 1110 1111 1110 0000

// Frame id, x, and y of proj1
explosion 1 frame id = 0001 0001 0010 0001
explosion 1 frame x coord = 0001 0001 0010 0000
explosion 1 frame y coord = 0001 0001 0001 1111

// Frame id, x, and y of proj2
explosion 2 frame id = 0001 0001 0001 1110
explosion 2 frame x coord = 0001 0001 0001 1101
explosion 2 frame y coord = 0001 0001 0001 1100

// Frame ids for players and projectiles
player 1 frame id = 0000 1111 0001 0000
player 2 frame id = 0000 1111 0001 0001
projectile 1 frame id = 0000 1111 0001 0010
projectile 2 frame id = 0000 1111 0001 0011

// Some global variables/counters
animation frame counter = 1111 0000 0000 0001
last player1 input = 1111 0000 0000 0010
last player2 input = 1111 0000 0000 0011

// this will hold the bitmap of the walls in the map so we can do collision detection
end of wall coordinates = 0001 0001 0001 1011
start of wall coordinates = 0000 1111 1111 0000

// holds glyph mapping for font
font scale = 0001 0001 0001 1110 (2 bits)
font map = 0001 0001 0001 1111 (size = 4800)


// Register conventions
REG0 - REG4 // temporary register
REG5 - REG10 // saved register
REG11 // Return address register
REG12 // Stack pointer
REG13 // Return value register
REG14 // arg1
REG15 // arg2
