package main

import (
	"encoding/json"
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

	js, err := json.Marshal(data)
	if err != nil {
		app.logger.Println(err)
		http.Error(w, "The server encountered a problem and could not process your request", http.StatusInternalServerError)
		return
	}

	js = append(js, '\n')

	w.Header().Set("Content-Type", "application/json")

	w.Write(js)
}
