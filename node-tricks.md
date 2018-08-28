[deasync](https://www.npmjs.com/package/deasync) is a handy package for scripts where blocking is not important:

```clojure
(ns some-script.core
  (:require
    ["deasync" :as deasync]
    ["request" :as request]))

(defn sync-request [url]
 ((deasync (fn [url cb] (.get request url (fn [err resp body] (cb err body)))))
  url))
  ```
