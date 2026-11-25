*** Settings ***
Documentation     Page Object : page de connexion.
Resource          ../common.resource


*** Variables ***
${LOGIN_HEADING}         xpath://h2[normalize-space()='Login']
${EMAIL_FIELD}           id:email-id
${PASSWORD_FIELD}        id:password
${REMEMBER_CHECKBOX}     id:remember
${LOGIN_SUBMIT_BUTTON}   id:submit-id


*** Keywords ***
Login Page Should Be Open
    Wait Until Element Is Visible    ${LOGIN_HEADING}
    Location Should Contain    /crm/login.html
    Page Should Contain Element    ${EMAIL_FIELD}
    Page Should Contain Element    ${PASSWORD_FIELD}

Input Login Credentials
    [Arguments]    ${email}    ${password}
    Input Text        ${EMAIL_FIELD}       ${email}
    Input Password    ${PASSWORD_FIELD}    ${password}

Select Remember Me
    Select Checkbox    ${REMEMBER_CHECKBOX}
    Checkbox Should Be Selected    ${REMEMBER_CHECKBOX}

Submit Login Form
    Click Button    ${LOGIN_SUBMIT_BUTTON}

Login Page Should Still Be Displayed
    [Documentation]    Apres un envoi invalide : l'utilisateur reste sur la page de login
    ...                et n'est pas connecte.
    Location Should Contain    /crm/login.html
    Page Should Not Contain    Our Happy Customers
    Page Should Contain Element    ${LOGIN_HEADING}

Login Field Should Be Flagged As Missing
    [Documentation]    Le navigateur marque le champ obligatoire comme vide (validation HTML5).
    [Arguments]    ${field_id}
    ${missing}=    Execute Javascript    return document.getElementById('${field_id}').validity.valueMissing;
    Should Be True    ${missing}    Le champ '${field_id}' devrait etre signale comme manquant.

Email Field Should Be Prepopulated
    [Arguments]    ${expected_email}
    Textfield Value Should Be    ${EMAIL_FIELD}    ${expected_email}
