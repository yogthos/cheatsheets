### Local Port forwarding

    ssh -L 9000:localhost:5432 remote-server

Forwards port `5432` from the `remote-server` to port `9000` on `localhost`.

### Check what's listening on a port

    netstat -tulpn | grep :80
  
or

   lsof -n -i:3000 | grep LISTEN
