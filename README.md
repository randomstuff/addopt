Configure environment for extra extra software packages (/opt/foobar) 
=====================================================================

Configure PATH, LD_RUN_PATH, MANPATH, CPATH ...

    $ node
    bash: node: command not found
    
    $ ls /opt/node0.9
    bin lin share
    
    $ . addopt.sh
    $ addopt /opt/node0.9
    $ node
    >^C
    
    $ man node
