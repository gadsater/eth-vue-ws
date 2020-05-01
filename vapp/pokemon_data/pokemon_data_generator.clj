(require '[clojure.string :as str])

(def pokelist (-> (slurp "pokemon.csv")
    (str/split #"\n")))