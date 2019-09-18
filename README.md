# Linux installer for eduPrint UU 

I maintain this repo because it suits my workflow. Since Uppsala university are kind enough
to share this code under the GPL I seen no reason to keep this repo private.

Feel free to use this repo if it suits you. But please note that I offer **no guarantees on this 
script being up-to-date**. If you want to be sure you have the latest eduprint UU script, 
[get it from MP directly](https://mp.uu.se/web/info/stod/it-telefoni/it-arbetsplats/utskrift/kom-igang-med-eduprint/eduprint-linux).


## Requirements

The script needs CUPS (`apt install cups`). The installer will not attempt to install 
it for you.

The installer *will* install samba-client and foomatic if they are not already installed on your 
system.



## Installation

The installer needs to be run with root permissions.  
And it is necessary to run the installer in place from the repo's working directory.

```
chepec$kemi.uu.se:~
$ git clone https://github.com/chepec/eduprint-uu.git
$ cd eduprint-uu
chepec@kemi.uu.se:~/eduprint-uu
$ sudo ./install-eduprint.sh
```



## Printing

When you print, eduprint should challenge you for a username/password.
Make sure to write `USER\<username>@user.uu.se` in the username field, and 
**password A** in the password field.

This has been tested to work, at least on my system (headless Ubuntu 18.04 
with i3wm).
