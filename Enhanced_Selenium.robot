
*** Keywords ***

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
