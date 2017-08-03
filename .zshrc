# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi
export PATH=$PATH:/

# user bin 
export PATH="$HOME/bin:${PATH}"

# scripts
export PATH="$HOME/scripts:${PATH}"

# python binaries
export PATH="$HOME/.local/bin:${PATH}"

# enable fasd autocompletion
eval "$(fasd --init auto)"

################# alias ###############################

# open a web browser on google for a query
function google {
    function urlencode {
        print "${${(j: :)@}//(#b)(?)/%$[[##16]##${match[1]}]}"
    }

    xdg-open "https://www.google.com/search?q=`urlencode "${(j: :)@}"`"
}

# separator
function hr {
    print ${(l:COLUMNS::=:)}
}

alias groclean='rm \#*'

setKeyboard() {
  setxkbmap -layout $1
}

# Gromacs stuff
# ==================================================
swapgmx() {
    if [ "$GMXBIN" = "/opt/gromacs-cuda/bin" ];
    then
	    gmxsbm;
    else
	    gmxcuda;
    fi
}
gmxsbm() {
    echo "Sourcing GROMACS SBM"
    source /opt/gromacs-sbm/bin/GMXRC
}
gmxcuda() {
    echo "Sourcing GROMACS cuda"
    source /opt/gromacs-cuda/bin/GMXRC
}

if [ -z "$GMXRC" ]; then
    GMXRC="/opt/gromacs-cuda/bin/GMXRC"
fi
source $GMXRC

=============================================

# perl
PATH="/home/bauer/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/bauer/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/bauer/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/bauer/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/bauer/perl5"; export PERL_MM_OPT;
