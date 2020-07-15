package egw

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"

	"acnodal.io/egw/web/util"
)

type Group struct {
	ID string
}
type Service struct {
	ID        string `json:"id,omitempty"`
	Name      string
	Address   string
	Self      string
	Endpoints string
}
type Endpoint struct {
	Address string
}

type ServiceCreateRequest struct {
	Group   Group
	Service Service
}
type EndpointCreateRequest struct {
	Group    Group
	Service  Service
	Endpoint Endpoint
}

func createService(w http.ResponseWriter, r *http.Request) {
	var body ServiceCreateRequest
	err := json.NewDecoder(r.Body).Decode(&body)
	if err != nil {
		util.RespondError(w)
	} else {
		svcid := 42
		fmt.Printf("POST service created %#v\n", body)
		util.RespondJson(w, fmt.Sprintf(`{"group": {"id": "%s"}, "service": {"id": "%d", "self": "%s%d/", "endpoints": "%s%d/endpoints/"}}`, body.Group.ID, svcid, r.RequestURI, svcid, r.RequestURI, svcid))
	}
}

func createEndpoint(w http.ResponseWriter, r *http.Request) {
	var body EndpointCreateRequest
	err := json.NewDecoder(r.Body).Decode(&body)
	if err != nil {
		util.RespondError(w)
	} else {
		vars := mux.Vars(r)
		svcid := vars["svcid"]
		fmt.Printf("POST endpoint created %#v\n", body)
		util.RespondJson(w, fmt.Sprintf(`{"group": {"id": "%s"}, "service": {"id": "%s"}}`, body.Group.ID, svcid))
	}
}

func SetupRoutes(router *mux.Router, prefix string) {
	egw_router := router.PathPrefix(prefix).Subrouter()
	egw_router.HandleFunc("/services/{svcid}/endpoints/", createEndpoint).Methods(http.MethodPost)
	egw_router.HandleFunc("/services/", createService).Methods(http.MethodPost)
}
