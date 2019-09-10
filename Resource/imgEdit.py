import numpy as np
# import matplotlib.pyplot as plt
from skimage import io


def disableBackground(img):
    new = np.copy(img)
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            # if np.array_equal(new[i][j],prev_color):
            #     new[i][j][3] = 0
            new[i][j][3] = 255
    return new

def colorQuantizer(img):
    new = np.copy(img)
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            for c in range(3):
                new[i][j][c] = new[i][j][c] & 0xE0 + 0b10000
    return new


OUT_PATH = '../project/ReadyToUse/' # output folder

while True:
    print('Enter "quit" or "exit" to terminate this program.')
    img_name = str(input("NOTE: Enter the image name (without '.png'):\n"))

    if img_name == 'quit' or img_name == 'exit':
        break
    try:
        img_original = io.imread(img_name + '.png')
        img_edited = disableBackground(img_original)
        # img_quantized = colorQuantizer(img_original)
        img_quantized = img_original
        io.imshow(img_quantized)
        io.show()
        feedback = str(input("Continue to generate txt file? (y/n)\n"))
        if feedback == 'Y' or feedback == 'y':
            outFile = open(OUT_PATH + img_name + '.txt', 'w')
            for y in range(img_quantized.shape[1]):
                for x in range(img_quantized.shape[0]):
                    # rgb = (img_quantized[x, y, 0] << 1) | (img_quantized[x, y, 1] >> 2) | (img_quantized[x,y,2] >> 5)
                    # outFile.write(format(rgb, 'b').zfill(9)+'\n')
                    r = img_quantized[x,y,0]
                    g = img_quantized[x,y,1]
                    b = img_quantized[x,y,2]
                    outFile.write(format(r, 'b').zfill(8))
                    outFile.write(format(g, 'b').zfill(8))
                    outFile.write(format(b, 'b').zfill(8)+'\n')
            outFile.close()
        io.imsave(OUT_PATH + img_name + '.png', img_quantized)
    except:
        print('An exception occurred. Please check the input file name.')

