# Docker for Yohoushi

## How to run Yohoushi as a container

### with docker run

Yohoushi uses GrowthForecast as graph servers, so first create a GrowthForecast container.

```
$ docker run -p 5125:5125 -d kazeburo/growthforecast --name growthforecast
```

Next run a Yohoushi container as below.

```
$ docker run -p 4804:4804 -d nikushi/yohoushi --link growthforecast:gf --name yohoushi
```

That's it. The container will listen on 4804/tcp on your Docker daemon so open Yohoushi top page by a browser. If your docker runs on Docker Machine, `docker-machine ip MACHINE_VM` returns the Docker host IP address, so you are able to open Yohoushi by your browser as below.

```
## In this example the machine name is `defaule`
$ open http://`docker-machine ip default`:4804
```

### run a Yohoushi container with existing GrowthForecast servers

If you already have a GrowthForecast outside the docker machine, instead of running a fresh empty GrowthForecast container as above, you can create a Yohoushi container linking to the existing GrowthForecast as below.

```
$ docker run -p 4804:4804 -d nikushi/yohoushi -e GF_URI=http://growthforecast.example.com:5125 --name yohoushi
```

### with Docker Compose

Instead of docker run, you can also launch GrowthForecast and Yohoushi containers as below.

```
$ docker-compse up -d
```

## How to build a Yohoushi docker image

Build as below on the project root,

```
$ docker build -rm -t yohoushi .
```

