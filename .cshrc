#--------------------------------------------------------------
#--               My shell prompt
#--------------------------------------------------------------
alias getprompt 'set prompt = "[`whoami`@`hostname`]$cwd=> "'
alias cd    'cd \!*;    getprompt'
alias pushd 'pushd \!*; getprompt'
alias popd  'popd \!*;  getprompt'
set prompt = "[`whoami`@`hostname`]$cwd=> "

#--------------------------------------------------------------
#--                Shell Preferences
#--------------------------------------------------------------
set filec
limit coredumpsize 0
set history = 80
set savehist = 40
set ignoreeof = 1
set autolist = 1
set histdup = erase

unset autologout
#--------------------------------------------------------------
#--                Aliases
#--------------------------------------------------------------
alias n nedit
alias ll 'ls -al'
alias lll 'ls -al | less'
alias h history
alias c clear
alias cp 'cp -ip'
alias mv 'mv -i'
alias f 'find . | xargs grep'

# better grepping
alias ggrep "grep -r -C1 -i --color=always -P '\!*' *"

alias allps  'ps -aef | grep dennison'

# emacs start
alias e      "emacs \!* &"

#--------------------------------------------------------------
#--             Project Aliases
#--------------------------------------------------------------

setenv CLIENT_AREA  dv8

alias clients 'cd /nfs/$CLIENT_AREA/mdennison'

# o68 Verification Root
alias 68tr        'setenv VERIFROOT /nfs/$CLIENT_AREA/mdennison/o68_dv\!:1; setenv VERIFSUBROOT trunk_\!:2; \
		    cd $VERIFROOT/$VERIFSUBROOT'
# once VERIFROOT set, these move within the client
alias croot      'cd $VERIFROOT/$VERIFSUBROOT/'
alias verif      'cd $VERIFROOT/$VERIFSUBROOT/verif/'
alias rtl        'cd $VERIFROOT/$VERIFSUBROOT/rtl/'
  
#--------------------------------------------------------------
#--             Path and Tool Stuff
#--------------------------------------------------------------

setenv PATH     ${PATH}:/nfs/users/mdennison/bin
