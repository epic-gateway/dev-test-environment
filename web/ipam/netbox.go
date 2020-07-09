package ipam

import (
	"net/http"

	"github.com/gorilla/mux"

	"acnodal.io/egw/web/util"
)

func listAddresses(w http.ResponseWriter, r *http.Request) {
	util.RespondJson(w, `{"count": 1, "results": [{"id": 1, "address": "172.30.254.2/32"}]}`)
}

func patchAddress(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
}

func SetupRoutes(router *mux.Router, prefix string) {
	ipam := router.PathPrefix(prefix).Subrouter()
	ipam.HandleFunc("/ip-addresses/", listAddresses).Methods(http.MethodGet)
	ipam.HandleFunc("/ip-addresses/{id:[0-9]+}/", patchAddress).Methods(http.MethodPatch)
}
