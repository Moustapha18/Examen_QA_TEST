*** Settings ***
Documentation     Page Object : page d'accueil du CRM.
Resource          ../common.resource


*** Variables ***
${HOME_BRAND_LINK}       link:Customer Service
${HOME_HEADING}          xpath://h2[normalize-space()='Customers Are Priority One!']
${SIGN_IN_LINK}          link:Sign In


*** Keywords ***
Home Page Should Be Open
    [Documentation]    Verifie les elements attendus de la page d'accueil.
    Wait Until Element Is Visible    ${HOME_HEADING}
    Location Should Contain    /crm/index.html
    Element Text Should Be    ${HOME_HEADING}    Customers Are Priority One!
    Page Should Contain Element    ${HOME_BRAND_LINK}
    Page Should Contain Element    ${SIGN_IN_LINK}

Click Sign In Link
    Click Link When Ready    ${SIGN_IN_LINK}
