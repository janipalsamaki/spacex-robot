*** Settings ***
Documentation   SpaceX robot. Retrieves data from SpaceX API. Demonstrates how
...             to use RequestsLibrary (create session, get response, validate
...             response status, pretty-print, get response as text, get
...             response as JSON, access JSON properties, etc.).
Resource        keywords.robot
Suite Setup     Setup
Suite Teardown  Teardown

*** Tasks ***
Log latest launch info
    Log latest launch
