### SOCKS Proxy

    ssh -D 127.0.0.1:1080 remote_ssh_server

Opens port `1080` on your local machine as a SOCKS proxy so all your HTTP traffic can be specified to go through the SSH tunnel and out `remote_ssh_server` on the other end.

### Local Port Forwarding

    ssh -L 9000:localhost:5432 remote-server

Forwards port `5432` from the `remote-server` to port `9000` on `localhost`.

### Remote Port Forwarding

    ssh –R 12345:horse:80 goat
    
You can point your web browser to `http://goat:12345`, it will show the
content as if you accessed `http://horse`. This time, you can only access port
`12345` on `goat` (no Gateway port). 

### Check what's listening on a port

    netstat -anp tcp | grep 3000
  
or

    lsof -n -i:3000 | grep LISTEN
    
### Git defaults

Allow all Git commands to use colored output, if possible:

    git config --global color.ui auto

Tell git-branch and git-checkout to setup new branches so that git-pull
will appropriately merge from that remote branch. Recommended. Without this,
you will have to add —track to your branch command or manually merge remote
tracking branches with “fetch” and then “merge”.

    git config --global branch.autosetupmerge true

Unqualified git merge to merge the current branch's configured upstream branch, rather than being an error. (git rebase always has this behaviour. Consistent!) You should still merge thoughtfully

    git config --global merge.defaultToUpstream true

Default pushing to the current remote branch

    git config --global push.default current
    
Alternatively, When pushing without giving a refspec, push the current branch to its upstream branch

    git config --global push.default tracking

[git examples](https://github.com/dineshs91/gits)

## Rewriting Git commits

#### check the history

    git log 

#### rebase the last `n` commits interactively

    git rebase -i HEAD~n

#### apply the changes

    git rebase --continue
    

#### Undo commit head
    
    git reset HEAD^    
 
[more](http://ohshitgit.com/), [even more](https://medium.com/@kannonboy/lesser-known-git-commands-151a1918a60#.tp1hqxlyl)
  
