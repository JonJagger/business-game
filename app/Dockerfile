FROM cyberdojo/sinatra-base:6b753be
LABEL maintainer=jon@jaggersoft.com

COPY . /app

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

ARG BG_PORT
ENV BG_PORT=${BG_PORT}
EXPOSE ${BG_PORT}

CMD [ "/app/up.sh" ]
