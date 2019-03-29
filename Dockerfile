FROM ubuntu:19.04 as build
RUN apt update
RUN apt install fpc -y
ADD . /src
RUN cd /src && make
RUN mv /src/snake /snake

FROM scratch
COPY --from=build /snake /snake
ENTRYPOINT ["/snake"]
