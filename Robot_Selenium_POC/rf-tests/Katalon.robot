*** Settings ***
Resource    ../rf-keywords/Requests.resource
Resource    ../rf-keywords/Websites.resource


*** Test Cases ***
Scenario5: Make Appointment and Validate Confirmation For All Facilities Through Parallel Iteration In Herokuapp Website
    [Documentation]    Scenario5: Make Appointment and Validate Confirmation For All Facilities Through Parallel Iteration In Herokuapp Website
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
    Open URL In Chrome Browser    ${DEMO_CURA_URL}
    Login To CURA Healthcare Service    ${LOGIN}[USERNAME]    ${LOGIN}[PASSWORD]
    ${Date}    Get Tomorrow Date
    @{Facilities}    Read Excel Data Into List
    Make Appointment And Confirm The Details    
    ...    @{Facilities}    
    ...    Visit_Date=${Date}[Day]    
    ...    Date=${Date}[Visit Date]    
    ...    First Name=${First Name}    
    ...    Last Name=${Last Name}    
    ...    Id=${Id}
    Logout The DEMO CURA Website
    Close Browser