---
id: spacex-robot
title: SpaceX robot
description: Tutorial for creating a software robot for fetching data from SpaceX API.
---

This simple robot fetches and logs latest launch data from [SpaceX API](https://github.com/r-spacex/SpaceX-API) using [RequestsLibrary](https://bulkan.github.io/robotframework-requests/).

## Prerequisites

> To complete this tutorial, you need a working [Python](https://www.python.org/) (version 3) installation. On macOS / Linux, you can open the terminal and try running `python3 --version` to check if you have the required Python installed. On Windows, you can open the command prompt and try running `py --version` to check if you have the required Python installed.

You will start by creating some setup files and scripts to aid with setting up and executing your robot. The scripts will also help other people who want to use your robot to get everything up and running easily.

## Project directory

Create a new `spacex-robot` directory. This directory will contain the robot script and other required resources.

## Requirements file

You are going to use some libraries when implementing your robot. To make installing them easier, you are going to provide the list of required libraries in a text file. [pip](https://pypi.org/project/pip/) can read this file and handle the installation for you.

Inside the `spacex-robot` directory, create a file by name `requirements.txt`. Paste the following libraries in the file:

```
requests
robotframework
robotframework-requests

```

## Installation script: macOS / Linux

Inside the `spacex-robot` directory, create a new `scripts` directory. This directory will contain the scripts for setting up and running your robot.

In the `scripts` directory, create a file by name `prepare.sh`. Paste the following _shell script_ in the `prepare.sh` file:

```bash
#!/bin/bash

python3 -m venv venv
. venv/bin/activate

pip install --upgrade wheel pip setuptools
pip install -r requirements.txt

```

Save the shell script.

Make sure the shell script has _execution permissions_ by running the following command in the terminal:

```bash
chmod u+x prepare.sh
```

Your directory structure should look like this:

```bash
spacex-robot
├── requirements.txt
└── scripts
    └── prepare.sh
```

Navigate to the `spacex-robot` directory.

Execute the installation script to setup required libraries by running the following command:

```bash
./scripts/prepare.sh
```

## Run script: macOS / Linux

To make running your robot easier, you are going to create a shell script for that purpose.

Inside the `scripts` directory, create a file by name `run.sh` and paste in the following shell script:

```bash
#!/bin/bash

. venv/bin/activate

python -m robot -d output -P libraries -P resources -P variables --logtitle "Task log" tasks/

```

Make sure the shell script has execution permissions by running the following command in the terminal:

```bash
chmod u+x run.sh
```

## Installation script: Windows

Inside the `spacex-robot` directory, create a new `scripts` directory. This directory will contain the scripts for setting up and running your robot.

In the `scripts` directory, create a file by name `prepare.bat`. Paste the following _Windows batch script_ in the `prepare.bat` file:

```batch
py -m venv venv
call venv\Scripts\activate

python -m pip install --upgrade pip
pip install -r requirements.txt

call venv\Scripts\deactivate

```

Save the batch script.

Your directory structure should look like this:

```bash
spacex-robot
├── requirements.txt
└── scripts
    └── prepare.bat
```

Navigate to the `spacex-robot` directory.

Execute the installation script to setup required libraries by running the following command:

```
scripts\prepare.bat
```

## Run script: Windows

To make running your robot easier, you are going to create a Windows batch script for that purpose.

Inside the `scripts` directory, create a file by name `run.bat` and paste in the following Windows batch script:

```batch
call venv\Scripts\activate

python -m robot -d output -P libraries -P resources -P variables --logtitle "Task log" tasks/

call venv\Scripts\deactivate

```

## Robot script

Inside the `spacex-robot` directory, create a directory by name `tasks`.

Inside the `tasks` directory, create a file by name `spacex-robot.robot`.

Paste the following Robot Framework code in the `spacex-robot.robot` file:

```robot
*** Settings ***
Documentation   SpaceX robot. Retrieves data from SpaceX API. Demonstrates how
...             to use RequestsLibrary (create session, get response, validate
...             response status, pretty-print, get response as text, get
...             response as JSON, access JSON properties, etc.).
Resource        keywords.resource
Suite Setup     Setup
Suite Teardown  Teardown

*** Tasks ***
Log latest launch info
    Log latest launch

```

## Keywords resource file

Inside the `spacex-robot` directory, create a directory by name `resources`.

Inside the `resources` directory, create a file by name `keywords.resource`.

Paste the following Robot Framework code in the `keywords.resource` file:

```robot
*** Settings ***
Library     RequestsLibrary
Variables   variables.py

*** Keywords ***
Setup
    Create Session  spacex  ${SPACEX_API_BASE_URL}  verify=True

Teardown
    Delete All Sessions

Log latest launch
    ${launch}=  Get latest launch
    Log info    ${launch}

Get latest launch
    ${response}=  Get Request     spacex        ${SPACEX_API_LATEST_LAUNCHES}
    Request Should Be Successful  ${response}
    Status Should Be              200           ${response}
    [Return]      ${response}

Log info
    [Arguments]       ${response}
    ${pretty_json}=   To Json   ${response.text}  pretty_print=True
    ${launch}=        Set Variable  ${response.json()}
    Log To Console    ${pretty_json}
    Log To Console    ${launch["mission_name"]}
    Log To Console    ${launch["rocket"]["rocket_name"]}

```

## Variables file

Inside the `spacex-robot` directory, create a directory by name `variables`.

Inside the `variables` directory, create a file by name `variables.py`.

Paste the following Python code in the `variables.py` file:

```py
SPACEX_API_BASE_URL = "https://api.spacexdata.com/v3"
SPACEX_API_LATEST_LAUNCHES = "/launches/latest"

```

## Running the robot

Your directory structure should look like this:

```bash
spacex-robot
├── requirements.txt
├── resources
│   └── keywords.resource
├── scripts
│   ├── prepare.sh (or prepare.bat)
│   └── run.sh (or run.bat)
├── tasks
│   └── spacex-robot.robot
└── variables
    └── variables.py

```

In the terminal, navigate to the `spacex-robot` directory and execute (run) the robot:

macOS / Linux:

```bash
./scripts/run.sh
```

Windows:

```
scripts\run.bat
```

## Summary

You executed a simple robot that fetches data from an API, congratulations!

During the process, you learned some basic features of the `RequestsLibrary`.
