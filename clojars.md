## deployment setup

create a token here https://clojars.org/tokens/

create a `~/.lein/credentials.clj`

```
{"https://repo.clojars.org"
 {:username "yogthos" :password "<token>"}}
```

encrypt the file

```
gpg --default-recipient-self -e credentials.clj > credentials.clj.gpg
```
