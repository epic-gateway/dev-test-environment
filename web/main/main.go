package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func listAddresses(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"count": 1, "results": [{"id": 1, "address": "172.30.254.2/32"}]}`))
}

func patchAddress(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/api/ipam/ip-addresses/", listAddresses).Methods(http.MethodGet)
	r.HandleFunc("/api/ipam/ip-addresses/{id:[0-9]+}/", patchAddress).Methods(http.MethodPatch)
	http.Handle("/", r)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
