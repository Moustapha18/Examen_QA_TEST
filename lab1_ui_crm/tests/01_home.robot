*** Settings ***
Documentation     Fonction "Home" - cahier de tests Customer Service.
Resource          ../resources/keywords/crm_flows.resource
Test Setup        Open CRM Browser
Test Teardown     Close CRM Browser
Test Tags         lab1    feature-home


*** Test Cases ***
TC-1001 Home Page Should Load
    [Documentation]    Cas 1001 | Niveau : systeme | Priorite : haute | Smoke
    ...
    ...    Pre-conditions : navigateur ouvert, page d'accueil chargee (Test Setup).
    ...    Etape 1 : examiner le contenu de la page d'accueil.
    ...    Resultat attendu : titre, lien "Sign In" et lien de marque presents.
    [Tags]    id-1001    smoke    priority-high    level-system
    Home Page Should Be Open
