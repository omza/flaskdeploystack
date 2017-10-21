FROM python:3.6-alpine3.6
MAINTAINER oliver@app-workshop.de

# Environments for app
# -------------------------------------------------------
ONBUILD ARG FLASK_DEPLOY_MODULE
ONBUILD ARG FLASK_DEPLOY_CALLABLE
ONBUILD ARG FLASK_DEPLOY_PORT
ONBUILD ARG FLASK_DEPLOY_DOMAIN
	
ONBUILD ENV FLASK_DEPLOY_MODULE ${FLASK_DEPLOY_MODULE}
ONBUILD ENV FLASK_DEPLOY_CALLABLE ${FLASK_DEPLOY_CALLABLE}
ONBUILD ENV FLASK_DEPLOY_PORT ${FLASK_DEPLOY_PORT}
ONBUILD ENV FLASK_DEPLOY_DOMAIN ${FLASK_DEPLOY_DOMAIN}

# Installations Supervisor py3k (dev version) & nginx
# ---------------------------------------------------------
RUN apk update && \
    apk upgrade && \
    apk add -u git nginx sed && \
	pip install --no-cache-dir setuptools-git && \
	pip install --no-cache-dir git+https://github.com/orgsea/supervisor-py3k.git && \
	pip install --no-cache-dir flask && \
	pip install --no-cache-dir gunicorn

# Dirs & Copy Context
# -------------------------------------------------------
RUN mkdir -p /usr/log && \
	mkdir -p /usr/app && \
	rm /etc/nginx/conf.d/default.conf && \
	rm /etc/nginx/nginx.conf

COPY ./flask-deploy-stack/gunicorn.conf.py /etc/gunicorn/gunicorn.conf.py
COPY ./flask-deploy-stack/supervisord.conf /etc/supervisor/supervisor.conf
COPY ./flask-deploy-stack/nginx.server.conf /etc/nginx/conf.d/nginx.server.conf
COPY ./flask-deploy-stack/nginx.conf /etc/nginx/nginx.conf
COPY ./flask-deploy-stack/app.py /usr/app/app.py

WORKDIR /usr/app/

# Volumes
# -------------------------------------------------------
VOLUME /usr/log/

# Config port and callable
ONBUILD RUN sed -i -e "s/app:app/${FLASK_DEPLOY_MODULE}:${FLASK_DEPLOY_CALLABLE}/g" /etc/supervisor/supervisor.conf &&\
	sed -i -e "s/listen 8000;/listen ${FLASK_DEPLOY_PORT};/g" /etc/nginx/conf.d/nginx.server.conf &&\
	sed -i -e "s/server_name _;/server_name ${FLASK_DEPLOY_DOMAIN};/g" /etc/nginx/conf.d/nginx.server.conf 

# Start & Stop
# -----------------------------------------------------------
ONBUILD EXPOSE ${FLASK_DEPLOY_PORT}

STOPSIGNAL SIGTERM

ENTRYPOINT ["supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisor.conf"]
