*** Settings ***
Resource    ../rf-keywords/Requests.resource
Resource    ../rf-keywords/Websites.resource


*** Test Cases ***
Scenario4 Enter First Name And Last Name From Scenario1 And Get ID From Scenario3 And In Demo Automation Tesing Website Enter ID Text Inside Frame
    [Documentation]    Enter First Name And Last Name From Scenario1 And Get ID From Scenario3 And In Demo Automation Tesing Website Enter ID Text Inside Frame
    Open URL In Chrome Browser    ${DEMO_QA_URL}
    ${First Name}    Get First Name From First Row Of Web Table
    ${Last Name}    Get Last Name From First Row Of Web Table
    Close Browser
    Create API Session
    ${POST Response}    Make POST Request    ${REQUEST}[PATH_PARAMETER]    ${First Name}    ${Last Name}
    ${Id}    Get ID From Response    ${POST Response}
    Log    The ID from the response is: ${id}
    Validate Response Status Code    ${POST Response}    201    Created
    Validate Response Header    ${POST Response}
    Open URL In Chrome Browser    ${DEMO_AUTOMATION_URL}
    Enter ID In Frame Text Box    ${Id}
    Close Browser
    