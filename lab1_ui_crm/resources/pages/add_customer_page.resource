*** Settings ***
Documentation     Page Object : formulaire d'ajout de client et page de succes.
Resource          ../common.resource


*** Variables ***
${ADD_CUSTOMER_HEADING}    xpath://h2[normalize-space()='Add Customer']
${EMAIL_ADDRESS_FIELD}     id:EmailAddress
${FIRST_NAME_FIELD}        id:FirstName
${LAST_NAME_FIELD}         id:LastName
${CITY_FIELD}              id:City
${STATE_LIST}              id:StateOrRegion
${GENDER_RADIO}            gender
${PROMO_CHECKBOX}          name:promos-name
${CANCEL_LINK}             link:Cancel
# Le bouton Submit de ce formulaire n'a ni id ni name : on cible son type.
${ADD_SUBMIT_BUTTON}       css:button[type='submit']
${SUCCESS_MESSAGE}         Success! New customer added.


*** Keywords ***
Add Customer Page Should Be Open
    Wait Until Element Is Visible    ${ADD_CUSTOMER_HEADING}
    Location Should Contain    /crm/add-customer.html
    Page Should Contain Element    ${EMAIL_ADDRESS_FIELD}

Fill Customer Form
    [Arguments]    ${email}    ${customer}
    Input Text    ${EMAIL_ADDRESS_FIELD}    ${email}
    Input Text    ${FIRST_NAME_FIELD}       ${customer}[first_name]
    Input Text    ${LAST_NAME_FIELD}        ${customer}[last_name]
    Input Text    ${CITY_FIELD}             ${customer}[city]
    Select From List By Value    ${STATE_LIST}    ${customer}[state]
    Select Radio Button When Ready    ${GENDER_RADIO}    ${customer}[gender]
    IF    ${customer}[promo]
        Select Checkbox When Ready    ${PROMO_CHECKBOX}
    END

Submit Customer Form
    Click Button    ${ADD_SUBMIT_BUTTON}

Cancel Add Customer
    Click Link When Ready    ${CANCEL_LINK}

Customer Success Should Be Displayed
    Wait Until Page Contains    ${SUCCESS_MESSAGE}
    Location Should Contain    /crm/customer-success.html
