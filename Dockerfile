FROM ubuntu
WORKDIR /usr/src/app
COPY release.sh ./
RUN chmod +x release.sh

CMD ["./release.sh"]
COPY . .