#!/bin/sh
# yes | mix hex.info && iex -S mix phoenix.server
yes | mix local.rebar --force && yes | mix hex.info && mix phoenix.server
