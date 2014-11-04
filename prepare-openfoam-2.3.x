#!/bin/sh

# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT
# NOT LIMITED TO,  THE IMPLIED WARRANTIES  OF MERCHANTABILITY  AND FITNESS FOR A PARTICULAR 
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL  THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY  
# DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING 
# BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;  LOSS OF USE,  DATA, OR 
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
# WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if [[ $1 == 'install' ]]
then 
  port selfupdate
  port upgrade outdated
  port install boost flex bison gcc47 git wget openmpi cgal ccache scotch metis
  port select --set mpi openmpi-mp-fortran
else
  echo "
  This script tries to prepare your system for installation 
  of OpenFOAM 2.3.x on your Mac. Run this as root:
    sudo $0 install 
  It is assumed you have MacPorts installed and installs the following packages:
    boost flex bison gcc47 git wget openmpi cgal ccache scotch metis
  if MacPorts is not present, you can get it here: 
    https://www.macports.org/
    
  October 2014 --- Ruud Vlaming  
  "
fi

