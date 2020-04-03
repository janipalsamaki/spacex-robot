---
id: http-api-robot-tutorial
title: HTTP API robot tutorial
description: Tutorial for creating a software robot for fetching data from SpaceX API using Robot Framework and RPA Framework.
---

![SpaceX logo](spacex-logo.png)

This simple software robot fetches and logs the latest launch data from [SpaceX API](https://github.com/r-spacex/SpaceX-API) using [RPA Framework](https://rpaframework.org/).

## Prerequisites

> To complete this tutorial, you need a working [Python](https://www.python.org/) (version 3) installation. On macOS / Linux, you can open the terminal and try running `python3 --version` to check if you have the required Python installed. On Windows, you can open the command prompt and try running `py --version` to check if you have the required Python installed.

## Create a directory for your software robot projects

Create a directory for your software robot projects. If you already have an existing directory for your projects, you can use that.

## Set up a virtual Python environment

Navigate to your projects directory in the terminal or the command prompt. Set up a virtual Python environment by running the following command:

Windows:

```
py -m venv venv
```

macOS / Linux:

```bash
python3 -m venv venv
```

Activate the Python virtual environment:

Windows:

```
venv\Scripts\activate
```

macOS / Linux:

```bash
. venv/bin/activate
```

## Install Robocode CLI

```bash
pip install robocode
```

## Initialize the software robot directory

```bash
robo init http-api
```

Navigate to the directory:

```bash
cd http-api
```

## Install RPA Framework

```bash
pip install rpa-framework
```

## Robot task file

Paste the following Robot Framework code in the `tasks/robot.robot` file:

```robot
*** Settings ***
Documentation   HTTP API robot. Retrieves data from SpaceX API. Demonstrates
...             how to use RPA.HTTP (create session, get response, validate
...             response status, pretty-print, get response as text, get
...             response as JSON, access JSON properties, etc.).
Resource        keywords.robot
Suite Setup     Setup
Suite Teardown  Teardown

*** Tasks ***
Log latest launch info
    Log latest launch

```

## Robot keywords file

Paste the following Robot Framework code in the `resources/keywords.robot` file:

```robot
*** Settings ***
Library     RPA.HTTP
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

Paste the following Python code in the `variables/variables.py` file:

```py
SPACEX_API_BASE_URL = "https://api.spacexdata.com/v3"
SPACEX_API_LATEST_LAUNCHES = "/launches/latest"

```

## Wrap the robot

```bash
robo wrap
```

## Run the robot

Windows:

```
robo run entrypoint.cmd
```

macOS / Linux:

```bash
robo run entrypoint.sh
```

Example response (cropped):

```json
{
    "crew": null,
    "details": "This mission will launch the third batch of Starlink version 1.0 satellites, from SLC-40, Cape Canaveral AFS. It is the fourth Starlink launch overall. The satellites will be delivered to low Earth orbit and will spend a few weeks maneuvering to their operational altitude of 550 km. The booster for this mission is expected to land on OCISLY.",
    "flight_number": 89,
    "is_tentative": false,
    "last_date_update": "2020-01-29T14:07:07.000Z",
    "last_ll_launch_date": "2020-01-29T14:06:00.000Z",
    "last_ll_update": "2020-01-29T14:07:07.000Z",
    ...
    "mission_id": [],
    "mission_name": "Starlink 3",
    "rocket": {
        "fairings": {
            "recovered": true,
            "recovery_attempt": true,
            "reused": false,
            "ship": "GOMSTREE"
        },
        "first_stage": {
            "cores": [
                {
                    "block": 5,
                    "core_serial": "B1051",
                    "flight": 3,
                    "gridfins": true,
                    "land_success": true,
                    "landing_intent": true,
                    "landing_type": "ASDS",
                    "landing_vehicle": "OCISLY",
                    "legs": true,
                    "reused": true
                }
            ]
        },
        "rocket_id": "falcon9",
        "rocket_name": "Falcon 9",
        ...
}
```

## Summary

You executed a simple software robot that fetches data from an API. Congratulations!

During the process, you learned some basic features of the [RPA Framework](https://pypi.org/project/rpa-framework/).
