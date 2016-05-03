FROM marcelocg/phoenix

RUN apt-get install -y postgresql-client

RUN mkdir /janitor
WORKDIR /janitor
