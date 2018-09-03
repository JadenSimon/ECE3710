module ALU( A, B, C, Opcode, Flags);
input [15:0] A, B;
input [3:0] Opcode;
output reg [15:0] C;
output reg [4:0] Flags;
// Flag [4] = Z
// Flag [3] = O
// Flag [2] =
// Flag [1] =
// Flag [0] =

parameter LOAD = 4'b0000;
parameter AND  = 4'b0001;
parameter OR   = 4'b0010;
parameter XOR  = 4'b0011;
parameter ADD  = 4'b0101;
parameter ADDU = 4'b0110;
parameter SUB  = 4'b1001;
parameter CMP  = 4'b1011;

always @(A, B, Opcode)
begin
    case (Opcode)
    LOAD:
        begin
        C = A;
        Flags[4:0] = 5'b00000;
        end
    AND:
        begin
        C = A & B;
        Flags[3:0] = 4'b0000;
        Flags[4] = C == 0;
        end
    OR:
        begin
        C = A | B;
        Flags[3:0] = 4'b0000;
        Flags[4] = C == 0;
        end
    XOR:
        begin
        C = A ^ B;
        Flags[3:0] = 4'b0000;
        Flags[4] = C == 0;
        end
    ADD:
        begin
        C = A + B;
        if (C == 0) Flags[4] = 1'b1;
        else Flags[4] = 1'b0;
        if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
        else Flags[2] = 1'b0;
        Flags[1:0] = 2'b00; Flags[3] = 1'b0;
        end
    ADDU:
        begin
        {Flags[3], C} = A + B;
        if (C == 0) Flags[4] = 1'b1;
        else Flags[4] = 1'b0;
        Flags[2:0] = 3'b000;
        end
    SUB:
        begin
        C = A - B;
        if (C == 0) Flags[4] = 1'b1;
        else Flags[4] = 1'b0;
        if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
        else Flags[2] = 1'b0;
        Flags[1:0] = 2'b00; Flags[3] = 1'b0;
        end
    CMP:
        begin
        if( $signed(A) < $signed(B) ) Flags[1:0] = 2'b11;
        else Flags[1:0] = 2'b00;
        C = 0;
        Flags[4:2] = 3'b000;
        end
    default:
        begin
            C = 0;
            Flags = 5'b00000;
        end
    endcase
end

endmodule
