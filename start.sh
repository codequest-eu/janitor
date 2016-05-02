#!/bin/sh
npm install
mix do deps.get, compile
iex -S mix phoenix.server