FROM mrrooijen/phoenix
RUN yes | apk add erlang-tools
RUN apk --no-cache add postgresql-client

ENV HOME=/janitor
RUN mkdir $HOME
WORKDIR $HOME

COPY mix.exs mix.exs
RUN yes | mix deps.get
RUN mix local.rebar --force
