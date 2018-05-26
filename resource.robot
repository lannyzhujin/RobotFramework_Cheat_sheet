*** Variables ***
${browser}        chrome
${chromium_bin}    C:\\Users\\path\\to\\Chromium\\bin\\chrome.exe
${download_dir}    C:\\Users\\path\\to\\Downloads\\

*** Keywords ***
Click Element Until Added To Page
    [Arguments]    ${locator}    ${locator_added}    ${max_retry}=30
    # Retry 30 times by default
    : FOR    ${i}    IN RANGE    1    ${max_retry}
    \    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${locator}
    \    Run Keyword And Ignore Error    Click Element    ${locator}
    \    Sleep    1s
    \    ${result}    ${returnvalue}    Run Keyword And Ignore Error    Page Should Contain Element    ${locator_added}
    \    Exit For Loop If    '${result}'=='PASS'

Click Element Until Deleted From Page
    [Arguments]    ${locator}    ${max_retry}=30
    # Retry 30 times by default
    : FOR    ${i}    IN RANGE    1    ${max_retry}
    \    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${locator}
    \    Run Keyword And Ignore Error    Click Element    ${locator}
    \    Sleep    1s
    \    ${result}    ${returnvalue}    Run Keyword And Ignore Error    Page Should Not Contain Element    ${locator}
    \    Exit For Loop If    '${result}'=='PASS'

FormatName
    [Arguments]    ${name}
    ${name}    Replace String    ${name}    ${SPACE}    _
    ${name}    Replace String    ${name}    -    _
    ${name}    Replace String    ${name}    (    _
    ${name}    Replace String    ${name}    )    _
    ${name}    Replace String    ${name}    .    _
    ${name}    Replace String    ${name}    /    _
    ${name}    Replace String    ${name}    \\    _
    ${name}    Replace String    ${name}    \#    _
    ${name}    Replace String    ${name}    :    _
    [Return]    ${name}
    
Open Chrome Browser
    [Arguments]    ${URL}    ${width}=1600    ${height}=900
    Open Browser    ${URL}    browser=${browser} 
    Set Window Size    ${width}    ${height}
    Go To    ${URL}

Open Chrome Headless
    [Arguments]    ${URL}    ${width}=1600    ${height}=900
    @{args}=    Create List    --headless    window-size=${width},${height}
    &{chrome_option}=    Create Dictionary    args=@{args}
    &{desired_capabilities}=    Create Dictionary    chromeOptions=&{chrome_option}
    Create Webdriver    ${browser}     desired_capabilities=${desired_capabilities}
    Go To    ${URL}
    
Open Chromium Browser
    [Arguments]    ${URL}    ${width}=1600    ${height}=900
    @{args}=    Create List    window-size=${width},${height}
    &{chrome_option}=    Create Dictionary    binary=${chromium_bin}    args=@{args}
    &{desired_capabilities}=    Create Dictionary    chromeOptions=&{chrome_option}
    Create Webdriver    ${browser}     desired_capabilities=${desired_capabilities}
    Go To    ${URL}

Open Chromium Headless
    [Arguments]    ${URL}    ${width}=1600    ${height}=900
    # Set args
    @{args}=    Create List    --no-sandbox    --headless    window-size=${width},${height}
    # Set prefs
    &{downloadBehavior}=    Create Dictionary    behavior=allow    downloadPath=${download_dir}
    &{prefs}=    Create Dictionary    credentials_enable_service=false    Browser.setDownloadBehavior=&{downloadBehavior}    download.default_directory=${download_dir}    download.directory_upgrade=True
    # Set chrome option
    &{chrome_option}=    Create Dictionary    binary=${chromium_bin}    args=@{args}    prefs=&{prefs}
    # Set desired capabilities
    &{desired_capabilities}=    Create Dictionary    chromeOptions=&{chrome_option}
    Create Webdriver    ${browser}     desired_capabilities=${desired_capabilities}
    
Scroll To Element
    [Arguments]    ${locator}
    ${x}=    Get Horizontal Position    ${locator}
    ${y}=    Get Vertical Position    ${locator}
    Execute Javascript    window.scrollBy(${x}, ${y});

Scroll Element Into View
    [Arguments]    ${element_xpath}
    Execute Javascript    var elmnt = document.evaluate("${element_xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; elmnt.scrollIntoView();

Wait Exists And Click Element
    [Arguments]    ${locator}
    # Wait and frontend loading exception handling
    Wait Until Page Contains Element    ${locator}
    #Wait Until Element Is Visible    ${locator}
    : FOR    ${i}    IN RANGE    1    5
    \    ${result}    ${returnvalue}    Run Keyword And Ignore Error    Click Element    ${locator}
    \    Exit For Loop If    '${result}'=='PASS' or """StaleElementReferenceException""" not in """${returnvalue}"""
    \    Sleep    0.5

Wait Exists And Input Text
    [Arguments]    ${locator}    ${text}
    # Wait and frontend loading exception handling
    Wait Until Page Contains Element    ${locator}
    : FOR    ${i}    IN RANGE    1    5
    \    ${result}    ${returnvalue}    Run Keyword And Ignore Error    Input Text    ${locator}    ${text}
    \    Exit For Loop If    '${result}'=='PASS' or """StaleElementReferenceException""" not in """${returnvalue}"""
    \    Sleep    0.5

Wait Until File Download Complete
    [Arguments]    ${path}    ${filename}    ${timeout}=30
    : FOR    ${i}    IN RANGE    1    ${timeout}
    \    Sleep    1s
    \    ${result}    ${returnvalue}    Run Keyword And Ignore Error    File Should Exist    ${path}${/}${filename}
    \    Exit For Loop If    '${result}'=='PASS'
