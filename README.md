# Linux installer for eduPrint UU 

UU does not maintain a repo for this, unfortunately.
They simply offer [a tarball for download](https://mp.uu.se/documents/432512/127186965/eduprint-linux.tgz) at [this instruction page](https://mp.uu.se/web/info/stod/it-telefoni/utskrift/kom-igang-med-eduprint/eduprint-linux).


## Requirements

The system needs to have Java (on Debian/Ubuntu something like `apt install default-jdk default-jre-headless` should suffice) and CUPS (`apt install cups`) installed. The installer will not attempt to 
install these dependencies for you.



## Installation

The installer needs to be run with root permissions.  
And it is necessary to run the installer in place from the repo's root directory.

```
chepec@kemi.uu.se:~/.local/git/eduprint-uu
$ sudo ./install-eduprint-client.sh
```


