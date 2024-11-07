These .bat files are for setting up a Visual Studio Code (VS Code) development environment for 
Windows 10/11.

# Step 1
Clone or download this repository (Just get the .bat files onto your device). I typically put
the extracted folder on the Desktop.

# Step 2
Run AS ADMINISTRATOR install_toolsVSCode.bat file.
If you have VS Code already installed, you may skip that portion when the installer pops up (just
cancel it).

# Step 3
Run AS ADMINISTRATOR the install_extensions.bat file.

# Step 4
Install the STSW STLINK Drivers from STMicroelectronics website. Which can be found here:
https://www.st.com/en/development-tools/stsw-link009.html

Once you have downloaded the ZIP file from the website, run AS ADMINISTRATOR the dpinst_amd64.exe
file to install the STLINK drivers. Failure to do so properly will cause the Flash Controller task
in the next steps to fail.

# Step 5
**MAKE SURE TO RUN VS CODE AS ADMINISTRATOR** *you can right click the shortcut to it and click* 
*properties and then advanced to set to always open as administrator for convenience*

Clone the following repository which will contain a basic on-board LD2 blink program for the 
Nucleo-F446RE. (You can also download the repository and open the folder in VS Code).
https://github.com/jakeclarey/STM32F446_VSCode

Within this project, open the .vscode folder and change the settings.json project_name variable to 
the name of the project folder you wish to work on. There are two projects to pick from initially, 
Blinky and BlinkyFaster. After choosing a project_name to use, open the tasks menu, ctrl+shft+b is
the default shortcut, and run the Flash Controller task. This will build the current project and 
flash it onto the attached Nucleo-F446RE board.

# Step 6
The rest is fairly self explanatory, but I would like to mention how to make a new project. To make
a new project, copy and paste either Blinky or BlinkyFaster and rename the folder to something of 
your choice. Then make sure to change the settings.json project_name variable to the name you gave
the new project.

From there you can add, remove, and edit any header or source files you create in the Inc or Src
directories as you wish for you project.

Note that you do not need to keep the Blinky and BlinkyFaster projects. You may remove these after
you have a good understanding of how the environment works. A reccommendation I have is to create a
"!Template" folder with an Inc and Src folder inside of it. Then in those Inc and Src folders, add
a template.h, a template.c, and a main.c in the respective folders. Customize these to your coding
organization style and any time you want to make a new project, copy and paste the !Template folder
and rename it to whatever new project you will be working on.
