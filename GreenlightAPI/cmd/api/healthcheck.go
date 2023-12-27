package main

import (
	"net/http"
)

func (app *application) healthcheckHandler(w http.ResponseWriter, r *http.Request) {
	// create a map which holds the information that we want to send in the response

	data := map[string]string{
		"status":      "available",
		"environment": app.config.env,
		"version":     version,
	}

	// pass the map to json.Marshal() function. This returns a []byte slice

	err := app.writeJSON(w, http.StatusOK, data, nil)
	if err != nil {
		app.logger.Println(err)
		http.Error(w, "The server encountered a problem and could not process your request", http.StatusInternalServerError)
		return
	}

}
