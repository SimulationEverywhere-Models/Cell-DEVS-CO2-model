from PIL import Image
import numpy as np
print('sdsaf')
def wf(w,h,count,type):
    f=open("roomco2.val","a")
    a='('+str(w)+','+str(h)+') = '+str(count)+' '+str(type)+' '+'-1'
    f.write(a+'\n')
    f.close()
img1=Image.open('house3.bmp')
img_array = np.array(img1)
shape = img_array.shape
print(shape)
height = shape[0]
width = shape[1]
for w in range(0,width):
    for h in range (0,height):
        (b,g,r) = img_array[h,w]
        if (b, g, r) == (0, 0, 0):#black
            wf(w,h,-10,-300)
        if (b, g, r) == (128, 128, 128):#gray
            wf(w,h,400,-500)
        if (b, g, r) == (255, 0, 0):#Red
            print('red')
            wf(w,h,500,-200)
        if (b, g, r) == (0, 0, 255):#Blue
            print('blue')
            wf(w,h,300,-600)
        if (b, g, r) == (255, 255, 0):#yellow
            wf(w,h,500,-800)
        if (b, g, r) == (0, 255, 0):#green
            wf(w,h,500,-900)
        if (b, g, r) == (0, 255, 255):
            wf(w,h,500,-1000)
print('done')
# % STATE VARIABLE LEGEND :
# %   conc = double : represents the CO2 concentration (units of ppm) in a given cell, can be any positive numbe, default value is 500ppm
# %
# %   type = -100 : normal cell representing air with some CO2 concentration
# %   type = -200 : CO2 source, constantly emits a specific CO2 output
# %   type = -300 : impermeable structure (ie: walls, chairs, tables, solid objects)
# %   type = -400 : doors, fixed at normal indoor background co2 level (500 ppm)
# %   type = -500 : window, fixed at lower co2 levels found outside (400 ppm)
# %   type = -600 : ventilation, actively removing CO2 (300 ppm)
# %   type = -700 : CO2 sensor(500pm)
# %   type = -800 : ducts
# %   type = -900 : movelable people
# %   type = -1000 : destination
