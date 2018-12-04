# This script requires Pillow
# Usage: python convert_image.py 'file_name'
# Outputs a .data file

from PIL import Image
import sys
import struct

for i in range(len(sys.argv) - 1):
    file_in = str(sys.argv[i + 1])
    file_out = file_in.split(".")[0] + ".data"
    img = Image.open(file_in)

    # Pads hexadecimal numbers to 4 characters
    def padhex(h):
        return h[2:].zfill(4)

    # Make sure the image uses RBGA
    if (len(img.split()) == 4):
        # Get the bytes for each value
        r, g, b, a = img.split()
        red_bytes = r.tobytes("raw")
        green_bytes = g.tobytes("raw")
        blue_bytes = b.tobytes("raw")
        alpha_bytes = a.tobytes("raw")

        # Write the upper 5 bits of every byte to the output
        # Alpha byte is converted to a single bit
        output = open(file_out, 'w')
        for i in range(len(red_bytes)):
            # First convert the byte to a 5-bit integer
            red_value = struct.unpack('>B', red_bytes[i])[0] / 8
            green_value = struct.unpack('>B', green_bytes[i])[0] / 8
            blue_value = struct.unpack('>B', blue_bytes[i])[0] / 8
            alpha_value = struct.unpack('>B', alpha_bytes[i])[0]

            # Packs each value into a 16-bit value
            # Alpha only checks if any bit is non-zero
            pixel = (red_value << 11) + (green_value << 6) + (blue_value << 1) + (alpha_value != 0)

            # print str(red_value) + ', ' + str(blue_value) + ', ' + str(green_value) + ', ' + str(alpha_value)
            output.write(padhex(hex(pixel)) + ' ')

            if (i % 32 == 31):
                output.write('\r\n')
    else:
        print "Please use a PNG file with transparency!"
