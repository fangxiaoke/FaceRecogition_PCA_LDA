import os
import shutil
import timeit

file_path = 'realSketch'
files = os.listdir(file_path)
files.sort()
for i, img in enumerate(files):
    if img.endswith('.jpg') or img.endswith('.png'):
        num = img.split('_')[0]
        shutil.move(file_path + '/' + img, file_path + '/' + num + '.jpg')
print(file_path + ' Done')
