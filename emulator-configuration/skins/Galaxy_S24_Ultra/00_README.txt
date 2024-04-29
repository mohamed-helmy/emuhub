EMULATOR SKIN
-------------
The skin consists of background, foreground, and buttons/keyboard.


* BACKGROUND
	
It is the phantom violet curved image with the device positioned at the center.

How to change device color?
Edit the ‘layout’ file and change the code below (Line 4) with the filename of the background image containing the device color you’ve chosen:

------------------------------------------        
	background {
            image   device_Port-*color*.png
        }
------------------------------------------

* FOREGROUND
	
The foreground is the image placed on top of the device screen to replicate device's notches, rounded corners, and punch-hole selfie cameras. 
If you wish to use the emulator skin without the foreground, just edit the ‘layout’ file and remove the lines below (Line 6-8):
	
------------------------------------------	
	foreground {
		mask	fore_port.png
	}
------------------------------------------


* BUTTONS
	
These buttons are just additional features that enable you to control the emulator skin aside from on-device buttons.

NOTE 
The Galaxy Emulator Skin defines only the appearance and controls of an Android Virtual Device (AVD), which still runs on a stock Android OS.

Emulator skins for Galaxy devices do not include any One UI features, since it only serves as a skin for an AVD. 
 
If you have any issues or questions, post them here: 
https://developer.samsung.com/support
https://forum.developer.samsung.com/

Have fun testing your apps with Galaxy Emulator Skins!

