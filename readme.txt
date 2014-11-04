Enclosed please find two scripts that may help you with the 
installation of openFOAM on your Mac. These are specific for 
the 'git version' of  openFOAM-2.3.x. It is assumed you have
MacPorts installed on your system, and have also prepared a 
case sensitive file system. For more information on these 
subjects see:
  https://www.macports.org/
  http://openfoamwiki.net/index.php/Installation/Mac_OS/OpenFOAM_2.2.2#Creation_of_Case_Sensitive_.sparseimage
  
The scripts are based upon:
  http://openfoamwiki.net/index.php/Installation/Mac_OS/OpenFOAM_2.2.2
  http://www.cfd-online.com/Forums/openfoam-installation-windows-mac/130113-compile-2-3-mac-os-x-patch.html
 
After downloading the scripts:
   git clone git://github.com/devlaam/openfoam-mac-install.git

After that, you can type:
  cd openfoam-mac-install
  ./prepare-openfoam-2.3.x 
  ./install-openfoam-2.3.x
Without arguments they present the latest help on their usage.
  
Basically you just have to type:
  sudo ./prepare-openfoam-2.3.x install
  ./install-openfoam-2.3.x install
  ./install-openfoam-2.3.x compile 
and you are ready to go.

October 2014 --- Ruud Vlaming
