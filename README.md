# flask-deploy-stack

> A mimimized Image based on python:alpine3.6 with nginx stable and dev version of Supervisor py3k

This image is intended for the rapid development and deployment of a web service in just one container . The image contains the following packages:

- alpine:3.6
- python 3.6.1
- pip 9.0.1
- nginx 1.12.1
- supervisor 4


## Getting started

In your Dockerfile start with 
```
FROM omza/flaskdeploystack
```

At runtime mount the Volumes for logfiles and the supervisord.conf file:
```
VOLUME /usr/log/
```

## Usage example

I use this Image as a base for different Proof of concepts and showcases e.g. my [diboards projects](https://github.com/omza/diboards). The project setup in short is:

- traefik for proxy, load balanace & ssl termination
- nginx to serve http static content and proxy to gunicorn
- gunicorn as wsgi server
- flask-restplus microframework/lib to provide a RESTful API 


## Meta

* **Oliver Meyer** - *app workshop UG (haftungsbeschränkt)* - [omza on github](https://github.com/omza)

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
