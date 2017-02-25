#!/bin/bash

# My crappy scripting cheat cheat. Just random thing I have learned, that most people can remember, but I just need a cheet sheet.

# Grab options
optstr=h:o
while getopts $optstr var
do
case $var in
h) Do when passed -h : means needs argument, passed as$OPTARG;;
o) do when passed -o;;
esac
done
shift $(( $OPTIND - 1 ))


# Function stuff
function stuff { # run "stuff" to start this function
echo "this stuff is run via the function"
{
stuff

# Echo stuff
blue='\033[0;34m'
red='\033[0;31m'
black='\033[0;30m'
green='\033[0;32m'
cyan='\033[0;36m'
purple='\033[0;35m'
brown='\033[0;33m'
gray='\033[0;37m'
yellow='\033[1;33m'
white='\033[1;37m'
NC='\033[0m' # to end the color
echo -e "${color}stuff${NC}"

echo {1..6} # echo 1 2 3 4 5 6

# Seq Stuff

seq 1 6 # Print 1-6 on indivual lines

# TR Stuff
echo Hi | tr 'Hi' 'By' # Replaces Hi with By, uses same amount of charaters.


# Awk stuff
awk 'FNR==2' # Print only second line.

#Sed stuff
# First always \ before special charaters in the sed except for the ones there now.
sed s'/what/now/g' # replace "what" with "now" in sdio (\n = newline)
sed s'/what/now/g' -i /path/to/file # replace "what" with "now" in file
sed s'/what.*//' # removes all after "what" per line.


# Read stuff
read variable # reads $variable from sdio

# Head Tail
head -n X # Show first X lines
head -n -X # Show all but last X lines
tail -n X # Show last X lines
tail -n +X # Show all but the first X lines
tail -f # Follow changes to file





# General stuff
echo $XDG_CONFIG_HOME #Show user config folder
echo $HOME # Might be better then using ~, and really better then using /home/$USER. Have to look into it
xset dpms force off # Force screen off.
nohup $program # Runs program in script, without waiting to exit.

# Package managment stuff
sudo pacman -Qen | awk '{print $1}' | tr '\n' ' ' # List stuff installed from repo's
yaourt -Qem | tr '/' ' ' | awk '{print $2}' | tr '\n' ' '  # List stuff installed from AUR
sudo pacman -Rcns $(pacman -Qdtq) # Remove random left over stuff


# Proxy crap
ssh -D 5686 $USERNAME@IP # SSH proxy open on localhost with port 5686
export http_proxy="127.0.0.1:5686"
export https_proxy="127.0.0.1:5686" # Sets up SSH HTTP and HTTPS proxy from terminal
export http_proxy="75.30.88.120:54699"
export https_proxy="75.30.88.120:54699" # Sets up Tor HTTP and HTTPS proxy from terminal


