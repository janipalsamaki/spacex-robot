#!/bin/bash

python3 -m venv venv
. venv/bin/activate

pip install --upgrade wheel pip setuptools
pip install -r requirements.txt
