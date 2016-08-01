### SOCKS Proxy

    ssh -D 127.0.0.1:1080 10.0.0.1
    
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
