*** Settings ***
Resource    ../rf-keywords/Requests.resource
Resource    ../rf-keywords/Websites.resource

*** Test Cases ***
Scenario3 Post Request With Retrieved First Name And Last Name From The Web Table
    [Documentation]    Scenario3 Post Request With Retrieved First Name And Last Name From The Web Table
    Open URL In Chrome Browser    ${DEMO_QA_URL}
    ${First Name}    Get First Name From First Row Of Web Table
    ${Last Name}    Get Last Name From First Row Of Web Table
    [Teardown]    Close Browser
    Create API Session
    ${POST Response}    Make POST Request    ${REQUEST}[PATH_PARAMETER]    ${First Name}    ${Last Name}
    ${Id}    Get ID From Response    ${POST Response}
    Log    The ID from the response is: ${id}
    Validate Response Status Code    ${POST Response}    201    Created
    Validate Response Header    ${POST Response}