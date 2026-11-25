*** Settings ***
Documentation     Fonction "Contacts" (clients) - cahier de tests Customer Service.
Resource          ../resources/keywords/crm_flows.resource
Test Setup        Open CRM Browser
Test Teardown     Close CRM Browser
Test Tags         lab1    feature-contacts


*** Test Cases ***
TC-1005 Customers Page Should Display Multiple Customers
    [Documentation]    Cas 1005 | Niveau : systeme | Priorite : haute | Smoke
    ...
    ...    Etapes : login valide, examen de la grille.
    ...    Resultat attendu : la grille contient plus d'1 ligne.
    ...    Reponse au "Challenge" du cahier : on compte les <tr> contenant des <td>.
    [Tags]    id-1005    smoke    priority-high    level-system
    Login As Admin
    Customers Grid Should Have More Than One Row

TC-1006 Should Be Able To Add New Customer
    [Documentation]    Cas 1006 | Niveau : acceptation | Priorite : haute | Smoke
    ...
    ...    Etapes : login, "New Customer", saisie du formulaire, "Submit".
    ...    Resultat attendu : la page de succes s'affiche.
    ...
    ...    Observation : le client ajoute n'apparait pas dans la grille apres
    ...    l'ajout (application de demonstration sans persistance) ; le cahier
    ...    n'exige pas cette verification, elle n'est donc pas testee.
    [Tags]    id-1006    smoke    priority-high    level-acceptance
    Login As Admin
    Open Add Customer Form
    ${email}=    Generate Unique Customer Email
    Fill Customer Form    ${email}    ${NEW_CUSTOMER}
    Submit Customer Form
    Customer Success Should Be Displayed

TC-1007 Should Be Able To Cancel Adding New Customer
    [Documentation]    Cas 1007 | Niveau : systeme | Priorite : basse | Fonctionnel
    ...
    ...    Etapes : login, "New Customer", "Cancel".
    ...    Resultat attendu : retour sur la page des clients.
    [Tags]    id-1007    functional    priority-low    level-system
    Login As Admin
    Open Add Customer Form
    Cancel Add Customer
    Customers Page Should Be Open
