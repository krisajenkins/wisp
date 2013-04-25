(import fs "fs")
(import [rest] "../sequence")
(import [str] "../runtime")
(import [read-all-from-string] "../reader")
(import [compile-program] "../compiler")

(set! global.**verbose** (<= 0 (.indexOf process.argv :--verbose)))

(defn transpile
  [source uri]
  (let [forms (read-all-from-string source uri)]
    (str (compile-program forms) "\n")))

;; Register `.wisp` file extension so that
;; modules can be simply required.
(set! (get require.extensions ".wisp")
  (fn [module uri]
    (._compile module
               (transpile (.read-file-sync fs uri :utf8))
               uri)))

