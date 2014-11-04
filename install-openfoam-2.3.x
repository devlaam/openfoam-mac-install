#!/bin/sh

# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT
# NOT LIMITED TO,  THE IMPLIED WARRANTIES  OF MERCHANTABILITY  AND FITNESS FOR A PARTICULAR 
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL  THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY  
# DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING 
# BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;  LOSS OF USE,  DATA, OR 
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
# WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if [[ $1 != 'install' &&  $1 != 'compile' ]]
then 
  echo "
  This script tries to get and install OpenFOAM 2.3.x on your
  Mac. It is assumed your machines is prepared. At least
  run prepare-openfoam-2.3.x and make sure you work on a
  case sensitive file system.
  
  Step1: To install OpenFOAM type: $0 install
  Step2: To compile OpenFOAM type: $0 compile
  
  This script is for 'one time' use only, meaning if it fails
  somewhere along the road, remove the directry OpenFOAM-2.3.x
  manually first and than rerun. 
  
  It is based on:
    http://openfoamwiki.net/index.php/Installation/Mac_OS/OpenFOAM_2.2.2
    http://www.cfd-online.com/Forums/openfoam-installation-windows-mac/130113-compile-2-3-mac-os-x-patch.html
  and changes i thought might be needed.

  Please note that between time of writing and you reading this some files might 
  have become unavailable. Then this script is broken, and usually that is a good
  thing, for most likely it cannot blindy be applied to successors of these files.
  
  Do not forget to start of with:
    source etc/bashrc
  every time you want to recompile your solver.

  October 2014 --- Ruud Vlaming
  "
  exit
fi  

# test if you are on a case sensitive file system
echo "OKAY" > caseTEST.temp; 
echo "FAIL" > casetest.temp; 

if [[ `cat caseTEST.temp` == "OKAY" ]] 
then
  echo "This file system is case sensitive, nice!"
  rm caseTEST.temp
  rm casetest.temp
else
  echo ""
  echo "  !!! OpenFOAM CANNOT be installed on a case insensitive file system, exit."
  echo "  For further information, see:"
  echo "  http://openfoamwiki.net/index.php/Installation/Mac_OS/OpenFOAM_2.2.2#Creation_of_Case_Sensitive_.sparseimage"
  echo ""
  rm casetest.temp
  exit 1
fi 

if [[ $1 == 'install' ]]
then
# Get OpenFOAM and patches from their repositories
LocalHome=$(pwd)
git clone git://github.com/OpenFOAM/OpenFOAM-2.3.x.git OpenFOAM-2.3.x
wget -OOpenFOAM-2.3.x-Mac.patch  http://sourceforge.net/p/openfoam-extend/svn/HEAD/tree/trunk/Breeder_2.3/distroPatches/MacPatch/OpenFOAM-2.3.x-Mac.patch?format=raw
cd OpenFOAM-2.3.x

# apply patches and make changes.
patch -p1<../OpenFOAM-2.3.x-Mac.patch
cd wmake/rules
ln -s darwinIntel64Gcc darwinIntel64Gcc46
ln -s darwinIntel64Gcc darwinIntel64Gcc47
ln -s darwinIntel64Gcc darwinIntel64Gcc48
cd ../..
chmod u+x bin/addr2line4Mac.py 

cp etc/bashrc etc/bashrc.ORG
cat << EINDE | patch etc/bashrc
--- bashrc
+++ bashrc
@@ -33,0 +34,4 @@
+HOME="${LocalHome}"
+export WM_CC='gcc-mp-4.7'
+export WM_CXX='g++-mp-4.7'
+export WM_NCOMPPROCS=$(sysctl -n hw.ncpu)
@@ -45 +49 @@
-foamInstall=\$HOME/\$WM_PROJECT
+foamInstall=\$HOME
@@ -66 +70 @@
-export WM_COMPILER=Gcc
+export WM_COMPILER=Gcc47
@@ -84 +88 @@
-export WM_MPLIB=OPENMPI
+export WM_MPLIB=SYSTEMOPENMPI
EINDE

cp applications/solvers/multiphase/driftFluxFoam/Make/options applications/solvers/multiphase/driftFluxFoam/Make/options.ORG
cat << EINDE | patch applications/solvers/multiphase/driftFluxFoam/Make/options
--- options
+++ options
@@ -25 +25,2 @@
-    -lcompressibleTurbulenceModels
\\ No newline at end of file
+    -lcompressibleTurbulenceModels \\
+    -ltwoPhaseMixture
\\ No newline at end of file
EINDE

fi

if [[ $1 == "compile" ]]
then
  cd OpenFOAM-2.3.x
  source etc/bashrc
  ./Allwmake 2>&1 | tee build.log
fi
