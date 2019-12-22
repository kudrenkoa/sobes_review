# SobesReview
Simple Phoenix app. Stores all your reviews in PostgreSQL db and sends you some kind of reports of this reviews.
# Features
* upload your reviews in csv files
* get your reports grouped by city, name, etc
### Tech
* [Elixir]
* [Phoenix]
* [Ecto] ofc
* [Materialize.css] for front
### Installation
```sh
$ cd sobesreview
```
Then change config/dev.exs file for your Postgres data
After that
```sh
$ mix deps.get
$ mix ecto.create && mix ecto.migrate
$ mix phx.server
```
And that's all!
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
