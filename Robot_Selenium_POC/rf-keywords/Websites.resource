*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Library    Collections
Library    OperatingSystem
Library    ExcellentLibrary
Library    ExcelLibrary

*** Variables ***
${DEMO_QA_URL}    https://demoqa.com/webtables
${DEMO_AUTOMATION_URL}    https://demo.automationtesting.in/Frames.html
${DEMO_CURA_URL}    https://katalon-demo-cura.herokuapp.com

&{WEBTABLE}
...    TXT_FIRST_NAME=(//div[@class="rt-tr -odd" and @role="row"])[1]/div[1]
...    TXT_LAST_NAME=(//div[@class="rt-tr -odd" and @role="row"])[1]/div[2]

&{FRAME}
...    SLT_FRAME=//iframe[@src="SingleFrame.html"]
...    TXT_INPUT=//input[@type='text']

&{LOGIN}
...    BTN_MAKE_APPOINTMENT=//a[@id='btn-make-appointment']
...    INP_TXT_USERNAME=//input[@id='txt-username']
...    INP_TXT_PASSWORD=//input[@id='txt-password']
...    BTN_LOGIN=//button[@id='btn-login']
...    USERNAME=John Doe
...    PASSWORD=ThisIsNotAPassword

&{MAKEAPPOINTMENT}
...    CHK_APPLY_HOSPITAL_READMISSION=//input[@id="chk_hospotal_readmission"]
...    RAD_MEDICAID=//input[@id="radio_program_medicaid"]
...    INP_DATE=//input[@id='txt_visit_date']
...    INP_COMMENT=//textarea[@id='txt_comment']
...    BTN_BOOK_APPOINTMENT=//button[@id='btn-book-appointment']
...    TXT_FACILITY=//p[@id='facility']
...    TXT_VISIT_DATE=//p[@id='visit_date']
...    TXT_COMMENT=//p[@id='comment']
...    LNK_APPOINTMENT=//a[@id='btn-make-appointment']

&{LOGOUT}
...    MENU_TOGGLE=//a[@id='menu-toggle']
...    LNK_LOGOUT=//a[normalize-space()='Logout']
...    TXT_SUMMARY=//section[@id='summary']//div[@class='row']

*** Keywords ***
Open URL In Chrome Browser
    [Documentation]    This Keyword Used To Verify Open Web Tables Page In Chrome Browser
    [Arguments]    ${URL}
    Open Browser    ${URL}    Chrome
    Maximize Browser Window

Get First Name From First Row Of Web Table
    [Documentation]    This Keyword Used To Verify Get First Name From First Row Of Web Table
    Wait Until Element Is Visible    ${WEBTABLE}[TXT_FIRST_NAME]
    Scroll Element Into View    ${WEBTABLE}[TXT_FIRST_NAME]
    ${First Name}    Get Text    ${WEBTABLE}[TXT_FIRST_NAME]
    Capture Page Screenshot
    RETURN    ${First Name}

Get Last Name From First Row Of Web Table
    [Documentation]    This Keyword Used To Verify Get Last Name From First Row Of Web Table
    Wait Until Element Is Visible    ${WEBTABLE}[TXT_LAST_NAME]
    Scroll Element Into View    ${WEBTABLE}[TXT_LAST_NAME]
    ${Last Name}    Get Text    ${WEBTABLE}[TXT_LAST_NAME]
    Capture Page Screenshot
    RETURN    ${Last Name}
    
Enter ID In Frame Text Box
    [Documentation]    Enters the provided ID into the text box within the frame.
    [Arguments]    ${ID}
    Wait Until Page Contains Element    ${FRAME}[SLT_FRAME]
    Select Frame    ${FRAME}[SLT_FRAME]
    Input Text    ${FRAME}[TXT_INPUT]    ${Id}
    Unselect Frame
    Capture Page Screenshot

Login To CURA Healthcare Service
    [Documentation]    This Keyword Verifies Login To CURA Healthcare Service
    [Arguments]    ${username}    ${password}
    Click Element    ${LOGIN}[BTN_MAKE_APPOINTMENT]
    Input Text    ${LOGIN}[INP_TXT_USERNAME]    ${username}
    Input Text    ${LOGIN}[INP_TXT_PASSWORD]    ${password}
    Click Button    ${LOGIN}[BTN_LOGIN]
    Capture Page Screenshot

Get Tomorrow Date
    [Documentation]    This Keyword Verifies Get Tomorrow's Date
    ${today}=    Get Current Date    result_format=%Y-%m-%d
    ${tomorrow}=    Add Time To Date    ${today}    1 day
    ${day}=    Convert Date    ${tomorrow}    %d
    ${month}=    Convert Date    ${tomorrow}    %m
    ${year}=    Convert Date    ${tomorrow}    %Y
    ${visit_date}=    Set Variable    ${day}/${month}/${year}
    &{Date}=    Create Dictionary    
    ...    Visit Date=${visit_date}
    ...    Day=${day}
    RETURN    ${Date}

Make Appointment And Confirm The Details
    [Documentation]    This Keyword Verifies Make Appointment
    [Arguments]    @{Facilities}    ${Visit_Date}    ${Date}    ${First Name}    ${Last Name}    ${Id}
    ${Counter}=    Set Variable    0
    ${Facilities Length}=    Get Length    ${Facilities}
    FOR    ${Facility}    IN    @{Facilities}
        ${Counter}=    Set Variable    ${${Counter} + 1}
        Log    Booking appointment for ${Facility}
        Select From List By Value    id=combo_facility    ${Facility}
        Click Element    ${MAKEAPPOINTMENT}[CHK_APPLY_HOSPITAL_READMISSION]
        Click Element    ${MAKEAPPOINTMENT}[RAD_MEDICAID]
        Click Element    ${MAKEAPPOINTMENT}[INP_DATE]
        
        # Remove leading zero from day (if any)
        ${day}=    Set Variable    ${Visit_Date}
        ${Convert Day}=    Evaluate    str(int('${day}'))
        Click Element    //td[@class='day'][normalize-space()='${Convert Day}']
        
        Input Text    ${MAKEAPPOINTMENT}[INP_COMMENT]    FirstName:${First Name}\nLastName:${Last Name}\nId:${Id}
        Capture Page Screenshot
        Click Button    ${MAKEAPPOINTMENT}[BTN_BOOK_APPOINTMENT]
        Page Should Contain    Appointment Confirmation

        ${Facility_Element}=    Get Text    ${MAKEAPPOINTMENT}[TXT_FACILITY]
        ${Visit_Date_Element}=    Get Text    ${MAKEAPPOINTMENT}[TXT_VISIT_DATE]
        ${Comment_Element}=    Get Text    ${MAKEAPPOINTMENT}[TXT_COMMENT]

        Should Be Equal As Strings    ${Facility_Element}    ${Facility}
        Should Be Equal As Strings    ${Visit_Date_Element}    ${Date}
        Should Contain    ${Comment_Element}    FirstName:${First Name}
        Should Contain    ${Comment_Element}    LastName:${Last Name}
        Should Contain    ${Comment_Element}    Id:${Id}
        Capture Page Screenshot

        # Skip navigation for the last iteration (Seoul)
        IF    ${Counter} <= ${Facilities Length}
            Wait Until Element Is Visible    ${MAKEAPPOINTMENT}[LNK_APPOINTMENT]
            Scroll Element Into View    ${MAKEAPPOINTMENT}[LNK_APPOINTMENT]
            Click Element    ${MAKEAPPOINTMENT}[LNK_APPOINTMENT]
        ELSE
            Skip
        END
    END

Logout The DEMO CURA Website
    [Documentation]    This Keyword Verifies Logout The DEMO CURA Website
    Click Element    ${LOGOUT}[MENU_TOGGLE]
    Wait Until Element Is Visible    ${LOGOUT}[LNK_LOGOUT]
    Click Element    ${LOGOUT}[LNK_LOGOUT]
    ${Status}=    Run Keyword And Return Status    
    ...    Page Should Not Contain Element    ${LOGOUT}[TXT_SUMMARY]
    Capture Page Screenshot

Read Excel Data Into List
    [Documentation]    Reads 4 rows of data from the first column in Sheet1.
    ${File Path}=    Set Variable    ..\\Robot_Selenium_POC\\rf-testdata\\Book1.xlsx
    Open Workbook    ${File Path}
    Switch Sheet    Sheet1
    @{Data List}=    Create List
    FOR    ${i}    IN RANGE    2    5
        ${Cell Value}=    Read From Cell    (1, ${i})  # (Column, row)
        Append To List    ${Data List}    ${Cell Value}
    END
    [Return]    ${Data List}
    Close Workbook