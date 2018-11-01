// Defines the instruction set used by our CPU.

// Upper 4 bits of the opcode define groups
parameter Register	= 4'b0000;
parameter Shift  		= 4'b1000;
parameter Special 	= 4'b0100;

// Register group
parameter AND  		= 4'b0001;
parameter OR   		= 4'b0010;
parameter XOR  		= 4'b0011;
parameter ADD  		= 4'b0101;
parameter ADDU 		= 4'b0110;
parameter ADDC 		= 4'b0111;
parameter SUB  		= 4'b1001;
parameter CMP  		= 4'b1011;
parameter MOV  		= 4'b1101;

// Special group
parameter LOAD			= 4'b0000;
parameter STOR			= 4'b0100;
parameter JAL			= 4'b1000;
parameter JCND			= 4'b1100;

// Shift group
parameter LSH 			= 4'b0100;
parameter LSHI 		= 3'b000;

// Immediate instructions located outside any group
parameter BCND 		= 4'b1100;
parameter ANDI  		= 4'b0001;
parameter ORI   		= 4'b0010;
parameter XORI  		= 4'b0011;
parameter ADDI  		= 4'b0101;
parameter ADDUI 		= 4'b0110;
parameter ADDCI 		= 4'b0111;
parameter SUBI  		= 4'b1001;
parameter CMPI  		= 4'b1011;
parameter MOVI  		= 4'b1101;
parameter LUI 			= 4'b1111;

// Register names for testing
parameter REG0			= 4'b0000;
parameter REG1			= 4'b0001;
parameter REG2			= 4'b0010;
parameter REG3			= 4'b0011;
parameter REG4			= 4'b0100;
parameter REG5			= 4'b0101;
parameter REG6			= 4'b0110;
parameter REG7			= 4'b0111;
parameter REG8			= 4'b1000;
parameter REG9			= 4'b1001;
parameter REG10		= 4'b1010;
parameter REG11		= 4'b1011;
parameter REG12		= 4'b1100;
parameter REG13		= 4'b1101;
parameter REG14		= 4'b1110;
parameter REG15		= 4'b1111;

// Condition codes		
parameter NC			= 4'b0000;
parameter EQ			= 4'b0001;
parameter NE			= 4'b0010;
parameter CS			= 4'b0011;
parameter CC			= 4'b0100;
parameter HI			= 4'b0101;
parameter LS			= 4'b0110;
parameter GT			= 4'b0111;
parameter LE			= 4'b1000;
parameter FS			= 4'b1001;
parameter FC			= 4'b1010;
parameter LO			= 4'b1011;
parameter HS			= 4'b1100;
parameter LT			= 4'b1101;
parameter GE			= 4'b1110;
parameter NJ			= 4'b1111;
