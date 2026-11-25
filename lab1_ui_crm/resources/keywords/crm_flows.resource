*** Settings ***
Documentation     Mots-cles metier : enchainements reutilisables (evite la duplication
...               des etapes de connexion entre les cas de test).
Resource          ../pages/home_page.resource
Resource          ../pages/login_page.resource
Resource          ../pages/customers_page.resource
Resource          ../pages/add_customer_page.resource
Resource          ../pages/sign_out_page.resource


*** Keywords ***
Login As Admin
    [Documentation]    Depuis la page d'accueil : ouvre la page de login, saisit les
    ...                identifiants valides, valide et verifie l'arrivee sur la liste clients.
    Click Sign In Link
    Login Page Should Be Open
    Input Login Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Submit Login Form
    Customers Page Should Be Open

Open Add Customer Form
    Click New Customer Button
    Add Customer Page Should Be Open

Generate Unique Customer Email
    [Documentation]    Email unique par execution (evite les collisions entre executions).
    ${epoch}=    Get Time    epoch
    RETURN    qa.${epoch}@example.com
