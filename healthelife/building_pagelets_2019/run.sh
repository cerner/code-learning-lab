#!/usr/bin/env sh

env FLASK_ENV=development FLASK_APP=pagelet.py flask run  --port=8000 --cert=cert.crt --key=pkey.key
