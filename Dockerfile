FROM python:3.6-alpine3.6
MAINTAINER oliver@app-workshop.de

# ARGs & ENVs
# -------------------------------------------------------
ENV APPLICATION_ENVIRONMENT Production

# dirs & volumes
# --------------------------------------------------------
RUN mkdir -p /usr/app/config/secrets/

VOLUME /usr/app/
VOLUME /usr/app/config/secrets/

# Install docker context
# ----------------------------------------------------------
COPY . /usr/app
WORKDIR /usr/app


# Install requirements
# ----------------------------------------------------------
RUN apk update && \
    apk upgrade && \
    apk add -u build-base openssl-dev libffi-dev && \
	pip install --no-cache-dir gunicorn && \
	#pip install --no-cache-dir -r requirements.txt && \
	apk del build-base