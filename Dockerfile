FROM marcelocg/phoenix
RUN yes | apt-get install erlang-tools
RUN apt-get install -y postgresql-client

ENV HOME=/janitor
RUN mkdir $HOME
WORKDIR $HOME

COPY mix.exs mix.exs
RUN yes | mix deps.get
RUN apt-get update
RUN yes | apt-get install erlang-tools
