# swayWM-Personal
Personal Configs

 1) get the dot files
 
 2) copy files to the right directories (.config of your user):
 
 3) copy scripts inside ~/.config/sway/scripts must be executable ! [chmod +x] them please ;)
 
 4) install needed packages (my needed packages check before you do this cause you won't need everything I want)

          git clone https://github.com/OdiousImp2604/swayWM-Personal

          cd swayWM-Personal

          cp -R config/* ~/.config/

          chmod -R +x ~/.config/waybar/scripts

          chmod -R +x ~/.config/sway/scripts

          yay -Syu --needed --noconfirm - < packages-repository.txt
