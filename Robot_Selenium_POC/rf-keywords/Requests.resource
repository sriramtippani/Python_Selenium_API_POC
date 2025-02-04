*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
&{REQUEST}    
...    BASE_URL=https://reqres.in    
...    URL_ENDPOINT_1=/api/users?page=1   
...    URL_ENDPOINT_2=/api/users?page=2
...    PATH_PARAMETER=/api/users

*** Keywords ***
Create API Session
    [Documentation]    This Keyword Verifies Create API Session
    Create Session    reqres_session    ${REQUEST}[BASE_URL]

Make GET Request
    [Documentation]    This Keyword Verifies Make GET Request
    [Arguments]    ${EndPoints}
    ${GET Response}    GET On Session    reqres_session    ${EndPoints}
    RETURN    ${GET Response}

Make POST Request
    [Documentation]    This Keyword Verifies Make POST Request
    [Arguments]    ${EndPoints}    ${First Name}    ${Last Name}
    &{Data}    Create Dictionary
    ...    first_name=${First Name}
    ...    last_name=${Last Name}
    ${POST Response}    POST On Session    reqres_session    ${EndPoints}    json=${Data}
    RETURN    ${POST Response}

Validate Response Status Code
    [Documentation]    This Keyword Verifies Validate Response Status Code
    [Arguments]    ${Response}    ${Expected Response}    ${Status Code Text}
    # For Status Code as number example: 200, 201
    Should Be Equal As Strings    ${Response.status_code}    ${Expected Response}
    # For Status Code Text example: OK
    Should Be Equal As Strings    ${Response.reason}    ${Status Code Text}
    
Validate Response Header
    [Documentation]    This Keyword Verifies Validate Response Header
    [Arguments]    ${Response}
    # Validated Content-Type in Header Section
    ${Content Type}    Get From Dictionary    ${Response.headers}    Content-Type
    Should Be Equal As Strings    ${Content Type}    application/json; charset=utf-8
    # Validated Connection in Header Section
    ${Connection}    Get From Dictionary    ${Response.headers}    Connection
    Should Be Equal As Strings    ${Connection}    keep-alive

Log Response Data
    [Documentation]    This Keyword Verifies Log Response Data
    [Arguments]    ${Response}
    Log    ${Response.json()}

Verify First And Last Names Not In Response
    [Documentation]    This Keyword Verifies Verify First And Last Names Not In Response
    [Arguments]    ${Response}    ${First Name}    ${Last Name}
    ${Response Body}    Set Variable    ${Response.json()}
    ${Response Text}    Evaluate    str(${Response Body})
    Should Not Contain    ${Response Text}    ${First Name}
    Should Not Contain    ${Response Text}    ${Last Name}
    
Get ID From Response
    [Documentation]    Extracts ID From The JSON Response
    [Arguments]    ${Response}
    ${Response JSON}    Set Variable    ${Response.json()}
    ${Id}    Get From Dictionary    ${Response JSON}    id
    RETURN    ${Id}