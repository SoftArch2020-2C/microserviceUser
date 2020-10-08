<<<<<<< HEAD
# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version:2.6.6

### Docker
fisrt build the image:

```sh
$ docker build -t froid_user_ms .
$ docker run --name "container_name" -d froid_user_ms 
```
You can test it by visiting http://container-ip:8080 in a browser or, if you need access outside the host, on port 8080:
```sh
$ docker run --name user_ms -p 3000:3000 -e POSTGRESS_HOST="host" -d froid_user_ms 
```
You can access to the swagger api documentation by visiting http://localhost:3000/api-docs.
