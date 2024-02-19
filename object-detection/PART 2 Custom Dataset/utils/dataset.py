# Copyright 2020 NVIDIA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import torch
import torch.utils.data
import glob
import subprocess
import cv2
import os
import uuid
import subprocess


class ImageCollect():
    
    def __init__(self, directory):
        self.directory = directory
        self._refresh()
    
    
    def __len__(self):
        return len(self.annotations)
    
    
    def _refresh(self):
        self.annotations = []
        for image_path in glob.glob(os.path.join(self.directory, '*.jpg')):
            self.annotations += [{
                'image_path': image_path,
            }]
    
    def save_entry(self, image):
        """Saves an image in BGR8 format to dataset for category"""

        filename = str(uuid.uuid1()) + '.jpg'
        
        if not os.path.exists(self.directory):
            subprocess.call(['mkdir', '-p', self.directory])
            
        image_path = os.path.join(self.directory, filename)
        cv2.imwrite(image_path, image)
        self._refresh()
        return image_path
    
    def get_count(self):
        i = 0
        for a in self.annotations:
          i += 1
        return i