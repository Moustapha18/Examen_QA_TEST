*** Settings ***
Documentation     Page Object : page "Signed Out".
Resource          ../common.resource


*** Variables ***
${SIGNED_OUT_HEADING}    xpath://h2[normalize-space()='Signed Out']


*** Keywords ***
Signed Out Page Should Be Open
    Wait Until Element Is Visible    ${SIGNED_OUT_HEADING}
    Location Should Contain    /crm/sign-out.html
