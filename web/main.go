package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"

	"acnodal.io/egw/web/egw"
	"acnodal.io/egw/web/ipam"
)

func main() {
	r := mux.NewRouter()

	ipam.SetupRoutes(r, "/api/ipam")
	egw.SetupRoutes(r, "/api/egw")

	http.Handle("/", r)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
