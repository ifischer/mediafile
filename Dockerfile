FROM python:3.7.4-slim

ENV PYTHONUNBUFFERED true
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /app

# Suppress pip upgrade warning
COPY pip.conf /root/.config/pip/pip.conf

RUN echo 'deb http://http.us.debian.org/debian/ testing non-free contrib main' >> /etc/apt/sources.list

RUN apt-get update \
  && apt-get install -y python2.7 python3.8 python3-distutils \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /usr/share/doc \
  && rm -rf /usr/share/man \
  && pip install tox \
  && apt-get clean

COPY requirements.txt .
COPY requirements-dev.txt .
RUN pip install -r requirements.txt
RUN pip install -r requirements-dev.txt

COPY . .
RUN pip install .
