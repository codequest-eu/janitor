# Janitor

To start: 
```
docker-compose build (to build)
docker-compose run --rm --service-ports web  (to run server in debugging mode - you can use IEx.pry ;))
```

General phoenix app steps: 
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:3000`](http://localhost:3000) from your browser. (if you have port forwarding.)
