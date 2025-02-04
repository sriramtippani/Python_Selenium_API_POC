*** Settings ***
Resource    ../rf-keywords/Websites.resource

Suite Teardown    Close Browser

*** Test Cases ***
Scenario1 Extract First Name And Last Name From Web Table
    [Documentation]    Scenario1 Extract First Name And Last Name From Web Table
    Open URL In Chrome Browser    ${DEMO_QA_URL}
    ${First Name}    Get First Name From First Row Of Web Table
    ${Last Name}    Get Last Name From First Row Of Web Table