# Takes the first argument(command line) as the input assembly file and outputs
# the corresponding machine code into another file. I don't know if this
# is the best way to do it in our situation but it can be easily changed
import sys
import numpy

# the file that will hold the machine code
output_file = open("machine_code.txt", "w")
# dictionary mapping reg to binary
reg_to_bin = { "REG0": "0000",
               "REG1": "0001",
               "REG2": "0010",
               "REG3": "0011",
               "REG4": "0100",
               "REG5": "0101",
               "REG6": "0110",
               "REG7": "0111",
               "REG8": "1000",
               "REG9": "1001",
               "REG10": "1010",
               "REG11": "1011",
               "REG12": "1100",
               "REG13": "1101",
               "REG14": "1110",
               "REG15": "1111" }
# dictionary mapping condition codes to binary
cond_to_bin = { "NC": "0000",
               "EQ": "0001",
               "NE": "0010",
               "CS": "0011",
               "CC": "0100",
               "HI": "0101",
               "LS": "0110",
               "GT": "0111",
               "LE": "1000",
               "FS": "1001",
               "FC": "1010",
               "LO": "1011",
               "HS": "1100",
               "LT": "1101",
               "GE": "1110",
               "NJ": "1111" }
# dictionary mapping player to binary
player_to_bin = {"player1" : "0000", "player2" : "0001"}
# dictionary that maps the labels to the addresses in the assembly file
label_addr = { }

def decode_instruction(line):
    # this just takes off the trailing newline character
    line = line.rstrip()
    line = line.lstrip()
    # if its an empty line we can just skip it
    if line == "":
        return
    # split the line so we can deal with the instruction in tokens
    instruction = line.split(' ')
    output_line = ""
    if instruction[0] == 'AND': # Basic register instructions
        output_line = "0000" + reg_to_bin[instruction[1]] + "0001" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'OR':
        output_line = "0000" + reg_to_bin[instruction[1]] + "0010" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'XOR':
        output_line = "0000" + reg_to_bin[instruction[1]] + "0011" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'ADD':
        output_line = "0000" + reg_to_bin[instruction[1]] + "0101" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'ADDU':
        output_line = "0000" + reg_to_bin[instruction[1]] + "0110" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'ADDC':
        output_line = "0000" + reg_to_bin[instruction[1]] + "0111" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'SUB':
        output_line = "0000" + reg_to_bin[instruction[1]] + "1001" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'CMP':
        output_line = "0000" + reg_to_bin[instruction[1]] + "1011" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'MOV':
        output_line = "0000" + reg_to_bin[instruction[1]] + "1101" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'LOAD': # Special Instructions
        output_line = "0100" + reg_to_bin[instruction[1]] + "0000" + reg_to_bin[instruction[1]]
    elif instruction[0] == 'STOR':
        output_line = "0100" + reg_to_bin[instruction[1]] + "0100" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'JAL':
        output_line = "0100" + reg_to_bin[instruction[1]] + "1000" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'JCND':
        output_line = "0100" + cond_to_bin[instruction[1]] + "1100" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'JCI':
        output_line = "0100" + reg_to_bin[instruction[1]] + "1111" + player_to_bin[instruction[2]]
    elif instruction[0] == 'PUSH':
        # subtract one from the stack pointer and then store at stack pointer
        output_line = "0100" + reg_to_bin[instruction[1]] + "0100" + reg_to_bin["REG12"] + "\n"
        output_line += "1001" + reg_to_bin["REG12"] + "00000001"
    elif instruction[0] == 'POP':
        # add one to the stack pointer then load the value at stack pointer
        output_line = "0101" + reg_to_bin["REG12"] + "00000001\n"
        output_line += "0100" + reg_to_bin[instruction[1]] + "0000" + reg_to_bin["REG12"]
    elif instruction[0] == 'LSH': # Shift Instructions
        output_line = "0100" + reg_to_bin[instruction[1]] + "1100" + instruction[2]
    elif instruction[0] == 'JCND':
        output_line = "0100" + cond_to_bin[instruction[1]] + "1100" + reg_to_bin[instruction[2]]
    elif instruction[0] == 'BCND': # Immediate Instructions
        output_line = "1100" + cond_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'ANDI':
        output_line = "0001" + reg_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'ORI':
        output_line = "0010" + reg_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'XORI':
        output_line = "0011" + reg_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'ADDI':
        output_line = "0101" + reg_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'ADDUI':
        output_line = "0110" + reg_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'ADDCI':
        output_line = "0111" + reg_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'SUBI':
        output_line = "1001" + reg_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'CMPI':
        output_line = "1011" + reg_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'MOVI':
        # if the Rdest starts with a '.' then we know we're jumping to a label
        if instruction[2][0] == ".":
            immediate_str = numpy.binary_repr(label_addr[instruction[2]], 16)
            output_line = "1111" + reg_to_bin[instruction[1]] + immediate_str[:8] + "\n"
            output_line += "0010" + reg_to_bin[instruction[1]] + immediate_str[8:]
        else:
            if len(instruction[2]) > 8:
                immediate_str = instruction[2]
                output_line = "1111" + reg_to_bin[instruction[1]] + immediate_str[:8] + "\n"
                output_line += "0010" + reg_to_bin[instruction[1]] + immediate_str[8:]
            else:
                output_line = "1101" + reg_to_bin[instruction[1]] + instruction[2]
    elif instruction[0] == 'LUI':
        output_line = "1111" + reg_to_bin[instruction[1]] + instruction[2]
    if output_line != "":
        output_file.write(output_line + " //" + line + "\n")
    else:
        if line[0] != '.' or line[0] != '/':
            print("Instruction not implemented: " + line)

def first_pass(input_file):
    # this will be the address of the line
    line_counter = 0
    for line in input_file:
        line = line.rstrip()
        line = line.lstrip()
        line = line.split(" ")
        # we don't want to count the newlines
        if line[0] == "":
            line_counter += 0
        elif line[0][0] == "/":
            line_counter += 0
        # the labels will start with a period e.g. .main
        elif line[0][0] == ".":
            label_addr[line[0]] = line_counter
        elif line[0] == "PUSH" or line[0] == "POP":
            line_counter += 2
        elif line[0] == "MOVI":
            if line[2][0] == ".":
                line_counter += 2
            elif len(line[2]) > 8:
                line_counter += 2
            else:
                line_counter += 1
        else:
            line_counter += 1

def main():
    # open the file thats given as the first argument
    try:
        input_file = open(str(sys.argv[1]), "r")
        second_input_file = open(str(sys.argv[1]), "r")
    except:
        print("File does not exist.")
    # Do the first pass to store all of the addresses for labels
    first_pass(input_file)
    # just loop through each line and decode the assembly and write it to the output file
    for line in second_input_file:
        decode_instruction(line)
    second_input_file.close()
    input_file.close()
    output_file.close()

if __name__ == '__main__':
    main()
