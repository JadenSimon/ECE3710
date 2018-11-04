# Takes the first argument as the input assembly file and outputs
# the corresponding machine code into another file. I don't know if this
# is the best way to do it in our situation but it can be easily changed
import sys

input_file = open(str(sys.argv[0]), "r")
output_file = open("machine_code.bin", "w")

def decode_instruction(line):
    # split the line so we can deal with the instruction in tokens
    instruction = line.split(' ')
    # we will first encode/decode the instruction and then the arguments later

    if instruction[0] == 'AND': # Basic register instructions
        output_line = "00000001"
    elif instruction[0] == 'OR':
        output_line = "00000010"
    elif instruction[0] == 'XOR':
        output_line = "00000011"
    elif instruction[0] == 'ADD':
        output_line = "00000101"
    elif instruction[0] == 'ADDU':
        output_line = "00000110"
    elif instruction[0] == 'ADDC':
        output_line = "00000111"
    elif instruction[0] == 'SUB':
        output_line = "00001001"
    elif instruction[0] == 'CMP':
        output_line = "00001011"
    elif instruction[0] == 'MOV':
        output_line = "00001101"
    elif instruction[0] == 'LOAD': # Special Instructions
        output_line = "01000000"
    elif instruction[0] == 'STOR':
        output_line = "01000100"
    elif instruction[0] == 'JAL':
        output_line = "01001000"
    elif instruction[0] == 'JCND':
        output_line = "01001100"


def main():
    # just loop through each line and decode the assembly and write it to the output file
    for line in input_file:
        decode_instruction(line)


if __name__ == '__main__':
    main()
