*** Settings ***
Resource    ../rf-keywords/Requests.resource
Resource    ../rf-keywords/Websites.resource

Suite Teardown    Close Browser

*** Test Cases ***
Scenario:2A Verify First Name And Last Name Not In Response Page 1
    [Documentation]    Scenario:2A Verify First Name And Last Name Not In Response Page 1
    Open URL In Chrome Browser    ${DEMO_QA_URL}
    ${First Name}    Get First Name From First Row Of Web Table
    ${Last Name}    Get Last Name From First Row Of Web Table
    [Teardown]    Close Browser
    Create API Session
    ${GET Response}    Make GET Request    ${REQUEST}[URL_ENDPOINT_1]
    Validate Response Status Code    ${GET Response}    200    OK
    Validate Response Header    ${GET Response}
    Verify First And Last Names Not In Response    ${GET Response}    ${First Name}    ${Last Name}
    Log Response Data    ${GET Response}

Scenario:2B Verify First Name And Last Name Not In Response Page 2
    [Documentation]    Scenario:2B Verify First Name And Last Name Not In Response Page 2
    Open URL In Chrome Browser    ${DEMO_QA_URL}
    ${First Name}    Get First Name From First Row Of Web Table
    ${Last Name}    Get Last Name From First Row Of Web Table
    [Teardown]    Close Browser
    Create API Session
    ${GET Response}    Make GET Request    ${REQUEST}[URL_ENDPOINT_2]
    Validate Response Status Code    ${GET Response}    200    OK
    Validate Response Header    ${GET Response}
    Verify First And Last Names Not In Response    ${GET Response}    ${First Name}    ${Last Name}
    Log Response Data    ${GET Response}