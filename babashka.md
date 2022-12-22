### command line args
 
```clojure
 (def my-args *command-line-args*)
```

### reading stdin

```clojure
(doseq [line (line-seq (clojure.java.io/reader *in*))]
  (println (clojure.string/upper-case line)))
```

### run shell commands

```clojure
(require '[babashka.process :refer [shell]])
(shell "whoami")
 
 ### set environment variable for shell command
 
```clojure
(require '[babashka.process :refer [shell]])
(shell {:extra-env {"FOO" "bar"}} "printenv" "FOO")
```

### capture output of a shell command

```clojure  
(require '[babashka.process :refer [sh]])
(def myname (:out (sh ["whoami"])))
```

### spawn a shell command in the background   

```clojure
(require '[babashka.process :refer [shell process]])

(let [p (process ["sh" "-c" "for i in `seq 3`; do date; sleep 1; done"]
                 {:out :inherit, :err :inherit})]
  (println "Waiting for result...")
  ;; dereference to wait for result
  @p)
```

### read command output line by line

```clojure
(require '[babashka.process :as p :refer [process destroy-tree]]
         '[clojure.java.io :as io])

(let [stream (process
              {:err :inherit
               :shutdown destroy-tree}
              ["cat" "/etc/hosts"])]

  (with-open [rdr (io/reader (:out stream))]
    (binding [*in* rdr]
      (loop []
        (when-let [line (read-line)]
          (println (str "#" line))
          (recur)))))

  ;; kill the streaming bb process:
  (p/destroy-tree stream)
  nil)
 
 (let [p (shell {:out :string} "cat" "/etc/hosts")]
  (doseq [line (clojure.string/split-lines (:out p))]
    (println (str "#" line))))
```

### find project folder

```clojure
 ;; Note that the `*file* form has to be evaluated at the top level of your file,
;; i.e. not in the body a function.
;;
;; Here fs/parent works similarly to the "dirname" Unix command.

(def project-root (-> *file* babashka.fs/parent babashka.fs/parent))

;; Print root folder
(println (str project-root))
```

### Copy, move, delete, read and write files

```clojure
(require '[babashka.fs :as fs])

(spit "world" "hello\n")
(fs/copy "world" "world2")
(spit "world2" "world\n" :append true)
(fs/delete "world")
(fs/move "world2" "world")
(print (slurp "world"))

;; Print filename in root folder
(println (str (babashka.fs/file project-root "README.txt")))
```

### work with dates and times

```clojure
(defn iso-date
  []
  (-> (java.time.LocalDateTime/now)
      (.format (java.time.format.DateTimeFormatter/ISO_LOCAL_DATE))))
 
 (defn iso-date-hm
  []
  (-> (java.time.LocalDateTime/now)
      (.format (java.time.format.DateTimeFormatter/ofPattern "yyyy-MM-dd---kk-mm"))))

(def fname (str "backup-" (iso-date) ".zip"))
```

### HTTP calls
 
```clojure
(require 
   '[cheshire.core :as cheshire]   
   '[org.httpkit.client :as http])

(defn fetch-data
  [path params]
  (-> @(http/get url {:query-params params})
      :body
      (cheshire/decode true)))
```
