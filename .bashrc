# .bashrc

#--------------------------------------------------------------
#--                Akeana global
#--------------------------------------------------------------

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
cd $HOME
source /proj/env/proj_env.bashrc
source /proj/cad/ALPINE/ENV/alpine.bashrc
umask 022
# User specific aliases and functions
alias cdw='cd /proj/work/${USER}'
alias pdw='pushd /proj/work/${USER}'
alias topmem='ps aux | head -1; ps aux | sort -rnk 4 | head -5'

alias lmstatsyn='lmstat -c $SNPSLMD_LICENSE_FILE'

export PATH=$PATH:/proj/cad/XILINX/Vivado/2021.1/bin

alias vcadconnect="/opt/cisco/anyconnect/bin/vpnui &"

#--------------------------------------------------------------
#--                Defines
#--------------------------------------------------------------

SVN_EDITOR=emacs
GIT_EDITOR=emacs

export PS1="[\h:\w]> "

#--------------------------------------------------------------
#--                Aliases
#--------------------------------------------------------------

alias ls='ls --color=auto'
alias ll='ls -ltra'
alias lll='ls -ltra | less'
alias cp='cp -ip'
alias mv='mv -i'
alias f='find . | xargs grep'
alias duhere='du --max-depth 1 -h'
alias df='df -h'
alias allps='ps -aef | grep mdennis+'
alias e='e_func'
alias gdiff='git difftool'
alias sbashrc="source ~/.bashrc"       # re-source this so i can get updates
alias simv='simvision_func'
alias rerun='rerun_func'
#alias vlaptop='vncserver -name mdennison -geometry 1920x1010'
alias vcloud='vncserver -name mdennison -geometry 3810x2100'
alias diffcl='diffcl_func'
alias smallscreen='xrandr -s 1920x1200'
alias bigscreen='xrandr -s 3810x2100'
alias diself='objdump_func'
alias mkhex='objcopy_func'
alias tycho='tycho_objcopy_func'
alias mauiwaves='mauiwaves_func'
alias extemudump='ext_emu_dump_func'
alias gcountsa="/proj/cad/CADENCE/VXE/VXE2303/bin/gateCount dldb xcva_top"

#--------------------------------------------------------------
#--             Project Aliases
#--------------------------------------------------------------
# my work area
CLIENT_AREA=/proj/work/${USER}
alias clients='cd $CLIENT_AREA'

alias setheretop='setheretop_func'
alias alpinetop='alpinetop_func'
alias integratetop='integratetop_func'
alias mauitop='mauitop_func'
alias qaevaltop='qaevaltop_func'
alias saevaltop='saevaltop_func'
alias shastatop='shastatop_func'

# once VERIFROOT set, these move within the client
alias vroot='cd $VERIFROOT/$VERIFSUBROOT'
alias yip='cd $VERIFROOT/$VERIFSUBROOT/alpine-ip/'
alias sip='cd $VERIFROOT/$VERIFSUBROOT/shasta-ip/'
alias tip='cd $VERIFROOT/$VERIFSUBROOT/turlock-ip/'
alias tuip='cd $VERIFROOT/$VERIFSUBROOT/tule-ip/'
alias folip='cd $VERIFROOT/$VERIFSUBROOT/folsom-ip/'
alias build='cd $VERIFROOT/$VERIFSUBROOT/build/'
alias lrun='cd $VERIFROOT/$VERIFSUBROOT/run/last/'
alias scripts='cd $VERIFROOT/$VERIFSUBROOT/tools/scripts/'

alias crtl='cd rtl-lib; git checkout pd/pd_dpmem_lib.sv pd/pd_mem_lib.sv; cd ..'

#--------------------------------------------------------------
#--             Path and Tool Stuff
#--------------------------------------------------------------

# path
PATH=$PATH:/user/mdennison/bin
#setenv PERL5LIB ${PERL5LIB}:/user/mdennison/bin/lib
if [[ -z $PYTHONPATH ]]; then
    PYTHONPATH=$PYTHONPATH:/user/mdennison/bin
else
    PYTHONPATH=/user/mdennison/bin
fi
alias mycommon='mycommon_func'    

#--------------------------------------------------------------
# alias functions
#--------------------------------------------------------------

e_func(){ emacs $@ & }
simvision_func(){ simvision -waves -64bit -debugdb $@ & }
rerun_func() {
    runTest.py -input $1 -keep 1 -dump 1 -msg_level debug -run_base ${*:2}
}
diffcl_func() {
    tkdiff ../../integration_$1/integration-env/$2 $2 
}
mycommon_func() {
    PATH=$1/bin:$PATH
    PYTHONPATH=$1/pylibs:$PYTHONPATH
}
setheretop_func(){
    VERIFROOT=$PWD/$1
    VERIFSUBROOT=.
    cd $VERIFROOT
}
alpinetop_func(){
    VERIFROOT=$CLIENT_AREA/alpine_$1
    VERIFSUBROOT=alpine-env
    cd $VERIFROOT/$VERIFSUBROOT
}
shastatop_func(){
    VERIFROOT=$CLIENT_AREA/shasta_$1
    VERIFSUBROOT=shasta-env
    cd $VERIFROOT/$VERIFSUBROOT
}
integratetop_func(){
    VERIFROOT=$CLIENT_AREA/integration_$1
    VERIFSUBROOT=integration-env
    cd $VERIFROOT/$VERIFSUBROOT
}
mauitop_func(){
    VERIFROOT=$CLIENT_AREA/maui_$1
    VERIFSUBROOT=maui-env
    cd $VERIFROOT/$VERIFSUBROOT
}
qaevaltop_func(){
    VERIFROOT=$CLIENT_AREA/integration_qa_eval_$1
    VERIFSUBROOT=integration-env
    cd $VERIFROOT/$VERIFSUBROOT
}
saevaltop_func(){
    VERIFROOT=$CLIENT_AREA/integration_sa_eval_$1
    VERIFSUBROOT=integration-env
    cd $VERIFROOT/$VERIFSUBROOT
}
tycho_objcopy_func(){
    cd $CLIENT_AREA/emu_linux
    mkdir $1
    cd $1
    cp /nfs/home/tychon/tmp/${2}/$1 .
    riscv64-unknown-elf-objcopy -O verilog $1 $1.hex
    program_map_emu.py -f $1.hex -p $3 -t lmem -o 128
    program_map_emu.py -f $1.hex -p $3 -t ddr0 -o 16
    mv lmem_$1.hex ~/$1.128b.hex
    mv ddr0_0_$1.hex ~/ddr_0_0_$1.hex
    mv ddr0_1_$1.hex ~/ddr_0_1_$1.hex
    rm $1.hex
}
objcopy_func(){
    riscv64-unknown-elf-objcopy -O verilog $1 $1.hex
    program_map_emu.py -f $1.hex -p $2 -t lmem -o 128
    mv lmem_$1.hex ~/$1.128b.hex
    rm $1.hex
}

tycho_uboot(){
    cd $CLIENT_AREA/emu_linux
    mkdir $1
    cd $1
    cp /nfs/home/tychon/tmp/${2}/$1 .
    riscv64-unknown-elf-objcopy -O verilog $1 $1.hex
    sed -e "s/\@000000080/\@000000081/g" $1.hex --in-place
    program_map_emu_ddr.py -f $1.hex -p $3 -t lmem -o 128
    mv lmem_$1.hex lmem.128b.hex
    program_map_emu.py -f $1.hex -p $3 -t ddr0 -o 16
    mv ddr0_0_$1.hex ddr0_0.hex
    mv ddr0_1_$1.hex ddr0_1.hex
    sed -e "s/\@000000081000/\@4/g" $1.hex > uboot_flash.hex
    sdimg=$(sed 's/u-boot/u-boot-sdcard/' <<< $1)
    sdimg=$(sed 's/elf/img/' <<< $sdimg)
    cp /nfs/home/tychon/tmp/${2}/$sdimg .
    tar -zcvf ~/$1.tar.gz uboot_flash.hex $sdimg lmem.128b.hex ddr0_0.hex ddr0_1.hex
    rm *.hex
}   

tycho_interleave(){
    cd $CLIENT_AREA/emu_linux
    mkdir $1
    cd $1
    cp /nfs/home/tychon/tmp/${2}/$1 .
    riscv64-unknown-elf-objcopy -O verilog $1 $1.hex
    sed -e "s/\@000000080/\@000000081/g" $1.hex --in-place
    program_map_emu.py -f $1.hex -p $3 -t interleave -o 512
    program_map_emu.py -f interleaved_program.hex -p $3 -t ddr0 -o 16
    program_map_emu.py -f interleaved_program.hex -p $3 -t ddr1 -o 16
    mv ddr0_0_interleaved_program.hex ddr0_0_int.hex
    mv ddr0_1_interleaved_program.hex ddr0_1_int.hex
    mv ddr1_0_interleaved_program.hex ddr1_0_int.hex
    mv ddr1_1_interleaved_program.hex ddr1_1_int.hex
    program_map_emu.py -f $1.hex -p $3 -t lmem -o 128
    program_map_emu.py -f $1.hex -p $3 -t ddr0 -o 16
    mv lmem_$1.hex lmem.128b.hex
    mv ddr0_0_$1.hex ddr0_0.hex
    mv ddr0_1_$1.hex ddr0_1.hex
    tar -zcvf ~/$1.tar.gz ddr0_0_int.hex ddr0_1_int.hex ddr1_0_int.hex ddr1_1_int.hex ddr0_0.hex ddr0_1.hex lmem.128b.hex
    rm *.hex
}   

tycho_ddr_interleave(){
    cd $CLIENT_AREA/emu_linux
    mkdir $1
    cd $1
    cp /nfs/home/tychon/tmp/${2}/$1 .
    riscv64-unknown-elf-objcopy -O verilog $1 $1.hex
    sed -e "s/\@000000080/\@000000081/g" $1.hex --in-place
    program_map_emu_ddr.py -f $1.hex -p $3 -t interleave -o 512
    program_map_emu_ddr.py -f interleaved_program.hex -p $3 -t ddr0 -o 16
    program_map_emu_ddr.py -f interleaved_program.hex -p $3 -t ddr1 -o 16
    mv ddr0_0_interleaved_program.hex ddr0_0_int.hex
    mv ddr0_1_interleaved_program.hex ddr0_1_int.hex
    mv ddr1_0_interleaved_program.hex ddr1_0_int.hex
    mv ddr1_1_interleaved_program.hex ddr1_1_int.hex
    program_map_emu_ddr.py -f $1.hex -p $3 -t lmem -o 128
    program_map_emu_ddr.py -f $1.hex -p $3 -t ddr0 -o 16
    mv lmem_$1.hex lmem.128b.hex
    mv ddr0_0_$1.hex ddr0_0.hex
    mv ddr0_1_$1.hex ddr0_1.hex
    tar -zcvf ~/$1.tar.gz ddr0_0_int.hex ddr0_1_int.hex ddr1_0_int.hex ddr1_1_int.hex ddr0_0.hex ddr0_1.hex lmem.128b.hex
    #rm *.hex
}   

objcopy_interleave(){
    riscv64-unknown-elf-objcopy -O verilog $1 $1.hex
    sed -e "s/\@000000080/\@000000081/g" $1.hex --in-place
    program_map_emu.py -f $1.hex -p $2 -t interleave -o 512
    program_map_emu.py -f interleaved_program.hex -p $2 -t ddr0 -o 16
    program_map_emu.py -f interleaved_program.hex -p $2 -t ddr1 -o 16
    mv ddr0_0_interleaved_program.hex ddr0_0_int.hex
    mv ddr0_1_interleaved_program.hex ddr0_1_int.hex
    mv ddr1_0_interleaved_program.hex ddr1_0_int.hex
    mv ddr1_1_interleaved_program.hex ddr1_1_int.hex
    program_map_emu.py -f $1.hex -p $2 -t lmem -o 128
    program_map_emu.py -f $1.hex -p $2 -t ddr0 -o 16
    mv lmem_$1.hex lmem.128b.hex
    mv ddr0_0_$1.hex ddr0_0.hex
    mv ddr0_1_$1.hex ddr0_1.hex
    tar -zcvf ~/$1.tar.gz ddr0_0_int.hex ddr0_1_int.hex ddr1_0_int.hex ddr1_1_int.hex ddr0_0.hex ddr0_1.hex lmem.128b.hex
    rm *.hex
}

objdump_func(){
    riscv64-unknown-elf-objdump -S --disassemble-all $1 > $1.dis
}
mauiwaves_func(){
    simvision $1 -input ../../maui.svcf
}
ext_emu_dump_func(){
    cd $CLIENT_AREA/emulator_traces
    mkdir $2
    cd $2
    tar -xvf ~/$1
    chmod 777 * *.shm *.shm/* *.shm/.phy
}
