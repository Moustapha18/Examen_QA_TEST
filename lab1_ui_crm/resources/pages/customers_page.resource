*** Settings ***
Documentation     Page Object : liste des clients ("Our Happy Customers").
Resource          ../common.resource


*** Variables ***
${CUSTOMERS_HEADING}       xpath://h2[normalize-space()='Our Happy Customers']
${NEW_CUSTOMER_LINK}       id:new-customer
${SIGN_OUT_LINK}           link:Sign Out
# Lignes de donnees uniquement (exclut la ligne d'en-tete qui ne contient que des <th>)
${CUSTOMER_ROWS}           xpath://table//tr[td]


*** Keywords ***
Customers Page Should Be Open
    Wait Until Element Is Visible    ${CUSTOMERS_HEADING}
    Location Should Contain    /crm/customers.html
    Page Should Contain Element    ${NEW_CUSTOMER_LINK}

Get Customer Row Count
    ${count}=    Get Element Count    ${CUSTOMER_ROWS}
    RETURN    ${count}

Customers Grid Should Have More Than One Row
    [Documentation]    Reponse au "Challenge" du cahier (cas 1005) : on compte les lignes
    ...                de donnees de la grille et on verifie qu'il y en a plus de 1.
    ${count}=    Get Customer Row Count
    Log    Nombre de clients affiches : ${count}
    Should Be True    ${count} > 1    La grille devrait contenir plus d'une ligne (trouve : ${count}).

Click New Customer Button
    Click Link When Ready    ${NEW_CUSTOMER_LINK}

Click Sign Out Link
    Click Link When Ready    ${SIGN_OUT_LINK}
