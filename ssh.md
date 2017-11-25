### simple port forwarding (SSH tunneling)

This example creates a tunnel for HTTP. This will forward port 80 of your localhost to port 80 of www.example.com.

    ssh -f -N -q -L 80:localhost:80 username@www.example.com

This example creates a tunnel for IMAP. Here we forward port 1143 on localhost to 143 (IMAP) on imap.example.com.

    ssh -f -N -q -L 1143:localhost:143 username@imap.example.com

* `-f` tells ssh to go into the background (daemonize).
* `-N` tells ssh that you don't want to run a remote command. That is, you only want to forward ports.
* `-q` tells ssh to be quiet
* `-L` specifies the port forwarding

#### port forwarding through an intermediary

You can have the remote machine forward ports to a third machine. This is useful where your have your local machine outside a firewall; a visible machine on the DMZ; and a third machine invisible to the outside.

This creates a tunnel from your localhost port 81 to 192.168.1.69 port 80 through dmz.example.com. This lets you see the web server from outside a LAN.

    ssh -f -N -q -L 81:192.168.1.69:80 username@dmz.example.com

This example creates a tunnel for SSH itself, over localhost port 2222.

    ssh -f -N -q -L 2222:target-host.example.com:22 username@dmz.example.com

This example creates a tunnel for IMAP. Here we forward port 1143 on localhost to 143 (IMAP) on 192.168.1.100 through dmz.example.com.

    ssh -f -N -q -L 1143:192.168.1.100:143 username@dmz.example.com

VNC Viewer uses port 5900. This shows a double-hop.

    # localhost  -->  wan-gateway  -->  dmz-gateway  -->  vnc-console
    ssh -L 5900:localhost:5900 root@wan-gateway.example.com
    ssh -L 5900:vnc-console.example.com:5900 root@dmz-gateway.example.com

### misc


Copy your SSH public key on a remote machine for passwordless login - the easy way 

    ssh-copy-id username@hostname
    
Mount folder/filesystem through SSH 

    sshfs name@server:/path/to/folder /path/to/mount/point

Compare a remote file with a local file 

    ssh user@host cat /path/to/remotefile | diff /path/to/localfile -

SSH connection through host in the middle 

    ssh -t reachable_host ssh unreachable_host

#### reverse port forwarding

This is used in the following situation:

* You have a server inside a private LAN that you want to connect to from the WAN outside.
* You can't create a NAT and port forwarding on your firewall to map the machine to the outside.
* You have a server outside that you can connect to from the server inside the LAN.

What this does is creates a connection from the server in the LAN to the server outside. Once that connection is established the server outside starts listening on port 2222. All connections to port 2222 are sent back to port 22 of the server in the LAN. Now you can leave this connection running in your office; go home and ssh to your proxy server at port 2222 and you will be connecting to your server inside the LAN on port 22.

    ssh -f -N -q -R 2222:localhost:22 my_name@remote.example.com

#### tricky reverse forwarding

This allows a server on an internal LAN expose a service to the outside WAN. For example, I have a database server that will only accept connections from a specific development box. That dev box is inside the firewall. I want to connect to the database from outside the firewall.

    ssh -t -L 5432:localhost:1999 my_name@firewall.example.com ssh -t db_server ssh -t -R 1999:127.0.0.1:5432 my_name@firewall

#### Using scp through a DMZ gateway to a machine behind a firewall using a tunnel

First you setup port forwarding through an intermediary. This forwards your localhost port 2222 to port 22 on 192.168.1.100. Remember, that 192.168.1.100 is not on your local network; 192.168.1.100 is on the LAN network shared with 208.77.188.166.

    ssh -f -N -q -L 2222:192.168.1.100:22 user@208.77.188.166
    scp -P 2222 transformers.avi user@localhost:.

A diagram might help. Remember, port 22 is the SSH server port on the 192.168.1.100 machine.

```
+---------------+        +----------------+        +----------------------+
|     your      |        |  remote DMZ    |        | server on remote LAN |
| local machine |        |    server      |        |    192.168.1.100     |
|               |        | 208.77.188.166 |        |                      |
|         2222:  >-------|                |-------> :22                   |
|               |        |\______________/|        |                      |
|               |        |                |        |                      |
+---------------+        +----------------+        +----------------------+
```
Other options

```
-o ExitOnForwardFailure=yes \
-o GSSAPIAuthentication=no \
-o GSSAPIAuthentication=no \
-o HashKnownHosts=no \
-o KbdInteractiveAuthentication=no \
-o PermitLocalCommand=yes \
-o LocalCommand="logger connected to %h" \
-o LocalForward=00:remote.example.com:000 \
-o ExitOnForwardFailure=yes \
-o NoHostAuthenticationForLocalhost=yes \
-o ProxyCommand=foo \ 
-o RemoteForward=foo \
-o RequestTTY=yes \
-o SendEnv=LC_* \
-o Tunnel=ethernet \
-o TunnelDevice=any:any \
-o VerifyHostKeyDNS=yes
```

### SOCKS5 with Firefox

Simple and secure web browsing. You can setup a tunnel as described above or you can use the following technique. This starts SSH on your localhost acting as a SOCKS proxy. Once you start SSH this way you can point any application that supports a SOCKS5 interface to this port. But these instructions will show what you need to do to get Firefox to proxy through SOCKS. Firefox supports SOCKS with no extra add-ons.
Start ssh an connection to a host that you want to proxy through. Use the -D option to specify a SOCKS5 port on your localhost. The port doesn't really matter. You just need to use the same port in your SOCKS client application.

    ssh -D 9999 username@proxy.example.com

In Firefox select "Edit | Preferences | Advanced Tab | Connection Settings button". Then select "Manual proxy configuration". All you need to fill out is "SOCKS Host: Localhost", "Port: 9999", then select "SOCKS v5". It's easy.
