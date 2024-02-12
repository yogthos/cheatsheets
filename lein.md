### creating deploy creds

First write your credentials map to `~/.lein/credentials.clj` like so:

```clojure
{#"blueant" {:password "locative1"}
 #"https://repo.clojars.org"
 {:username "milgrim" :password "CLOJARS_677eb77a08974e2797bbd17a402464e5cd0f987689487633895e649b312e"}
 "s3p://s3-repo-bucket/releases"
 {:username "AKIAIN..." :passphrase "1TChrGK4s..."}}
```

When storing credentials for Clojars, it's recommended to generate a deploy token per machine and store that instead rather than having a single deploy token in order to limit the scope of the damage if the credential is leaked.

Then encrypt it with gpg:

```shell
$ gpg --default-recipient-self -e \
    ~/.lein/credentials.clj > ~/.lein/credentials.clj.gpg
```
