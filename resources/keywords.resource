*** Settings ***
Library         RequestsLibrary
Variables       variables.py

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
