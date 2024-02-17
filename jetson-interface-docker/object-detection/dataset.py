import torch
import torch.utils.data
import glob
import PIL.Image
import subprocess
import cv2
import os
import uuid
import subprocess


class ImageCollect():
    
    def __init__(self, directory):
        self.directory = directory
        self._refresh()
         
                 
    def _refresh(self):
        self.annotations = []
        
        for image_path in glob.glob(os.path.join(self.directory, '*.jpg')):
            self.annotations += [{
                'image_path': image_path
            }]

    def save_entry(self, image):
                    
        filename = str(uuid.uuid1()) + '.jpg'
        
        if not os.path.exists(self.directory):
            subprocess.call(['mkdir', '-p', self.directory])
            
        image_path = os.path.join(self.directory, filename)
        print(image_path)
        cv2.imwrite(image_path, image)
        self._refresh()
        return image_path
    
    def get_count(self):
        i = 0
        for a in self.annotations:
            i += 1
        return i