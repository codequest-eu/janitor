FROM marcelocg/phoenix

RUN mkdir ~/npm-global
RUN npm config set prefix '~/npm-global'

ENV PATH  ~/npm-global/bin:$PATH

RUN npm install -g nodemon --save

RUN apt-get install -y postgresql-client

ENV HOME=/janitor
RUN mkdir $HOME
WORKDIR $HOME

COPY mix.exs mix.exs
RUN yes | mix deps.get
