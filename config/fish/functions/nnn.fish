export NNN_PLUG='o:fzopen;m:nmount;x:_chmod +x $nnn;u:gofile;w:_wofer $nnn;i:imgur'
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export NNN_OPENER=$HOME/.config/nnn/plugins/launcher
export NNN_BMS='c:~/.config/;p:~/projects/;j:~/java;s:~/School'
set --export NNN_FIFO '/tmp/nnn.fifo'
alias nnn "/usr/local/bin/nnn -C -c -A -Q $argv"

