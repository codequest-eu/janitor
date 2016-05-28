#!/bin/sh
if [ $DEBUG = "true" ]
  then 
    echo 'DEBUG MODE ON -------------------------'
    yes | mix hex.info && iex -S mix phoenix.server
  else 
    yes | mix hex.info && mix phoenix.server
fi