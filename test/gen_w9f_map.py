# generates map of 9x15 font definition to an rgba png image data array

num_pix_rows = 16
pix_row_indent = 8 * " "

num_pix_rows = 256

def print_pix_row_hdr(pix_row):
  print("pix_row %02d" % (pix_row))

def print_ch_num_hdr(pix_row):
  # each row has 16 chars 
  # each char has 2*8*4 byte offsets which are 5 digits each + 1 space:
  # 2*8*4*6 = 384
  # the char label itself is 'chXX.rowXX' which is 10 spaces
  # so padding is 384 - 10 = 374 spaces
  ln = ""
  num_chars = 16
  ln += "%s" % (pix_row_indent)
#  nspace =  16 * 20 - 4
  nspace = 374
  first_ch_num = pix_row / 16 * 16
  ch_row = pix_row % 16
  for i in range(0, num_chars):
    ln += "ch%02x.row%02x%s" % (first_ch_num + i, ch_row, " " * nspace)
  print ln

def print_pix_hdr(pix_row):
  # each row has 16 chars @ 16 pixels / char = 256 pixels
  num_pixels = 8 * 16
  ln = ""
  ln += "%s" % (pix_row_indent)
  for i in range(0, 16):
    for j in range(0, 16):
      ln += "p%04d%s" % (j, " " * 15)
  print ln

def print_rgba_hdr(pix_row):
  num_pixels = 16 * 16
  ln = ""
  ln += "%s" % (pix_row_indent)
  for i in range(0, num_pixels):
    ln += "r    g    b    a    "
  print ln

def print_img_data_offsets(pix_row):
#  k = pix_row * 16 * 16 * 4
#  num_pixels = 16 * 16
  # for each row, there are: 
  #  16 chars
  #  16 * 2 bitmask blocks
  #  16 * 2 * 8 pixels
  #  16 * 2 * 8 * 4 bytes
  num_bytes = 16 * 2 * 8 * 4
  first_byte = pix_row * num_bytes
  ln = ""
  ln += "%s" % (pix_row_indent)
  k = first_byte
  for i in range(0, num_bytes):
      ln += "%05x " % (k)
      k += 1
  print ln

def print_pixel_row(pix_row):
  # print pixel label row
  # print rgba row
  # print 16 byte rows
#  pixels_per_char = 16
#  bytes_per_pixel = 4
#  bytes_per_char = bytes_per_pixel * pixels_per_char
#  chars_per_row = 16
#  bytes_per_row = chars_per_row * bytes_per_char
#  byte_offset = pix_row * bytes_per_row

  print_pix_row_hdr(pix_row)
  print_ch_num_hdr(pix_row)
#  print_pix_hdr(pix_row)
#  print_rgba_hdr(pix_row)
  print_img_data_offsets(pix_row)
  

def main():
  for r in range(0, num_pix_rows):
    print_pixel_row(r)

main()
