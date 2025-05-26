package main

import (
	"fmt"
	"greenlight/internal/data"
	"net/http"
	"time"
)

func (app *application) createMovieHandler(w http.ResponseWriter, r *http.Request) {

	fmt.Fprintln(w, "from new movie")
}

func (app *application) showMovieHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Show  movie")
	id, err := app.readIDParam(r)
	if err != nil || id < 1 {
		http.NotFound(w, r)
		return
	}

	movie := data.Movie{
		ID:        id,
		CreatedAt: time.Now(),
		Title:     "Casablannca",
		Runtime:   102,
		Generes:   []string{"drama", "romance", "war"},
		Version:   1,
	}

	err = app.writeJSON(w, http.StatusOK, envelope{"movie": movie}, nil)
	if err != nil {
		app.logger.Println(err)
		http.Error(w, "The server encountered a prooblem and could not process your request",
			http.StatusInternalServerError)
	}
}
