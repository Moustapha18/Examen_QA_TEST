*** Settings ***
Documentation     Fonction "Login" - cahier de tests Customer Service.
Resource          ../resources/keywords/crm_flows.resource
Test Setup        Open CRM Browser
Test Teardown     Close CRM Browser
Test Tags         lab1    feature-login


*** Test Cases ***
TC-1002 Login Should Succeed With Valid Credentials
    [Documentation]    Cas 1002 | Niveau : systeme | Priorite : haute | Smoke
    ...
    ...    Etapes : clic "Sign In", saisie d'identifiants valides, clic "Submit".
    ...    Resultat attendu : la page des clients se charge.
    [Tags]    id-1002    smoke    priority-high    level-system
    Click Sign In Link
    Login Page Should Be Open
    Input Login Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Submit Login Form
    Customers Page Should Be Open

TC-1003-A Login Should Fail With Missing Credentials
    [Documentation]    Cas 1003 (premier) | Niveau : systeme | Priorite : moyenne | Fonctionnel
    ...
    ...    Note : l'Id 1003 est utilise deux fois dans le cahier ; ce cas est suffixe "-A".
    ...    Etapes : clic "Sign In", identifiants laisses vides, clic "Submit".
    ...    Resultat attendu : l'utilisateur reste sur la page de login, non connecte.
    [Tags]    id-1003-A    functional    priority-medium    level-system
    Click Sign In Link
    Login Page Should Be Open
    Log    Les identifiants sont volontairement laisses vides.
    Submit Login Form
    Login Page Should Still Be Displayed
    Login Field Should Be Flagged As Missing    email-id
    Login Field Should Be Flagged As Missing    password

TC-1003-B Remember Me Checkbox Should Persist Email Address
    [Documentation]    Cas 1003 (second) | Niveau : systeme | Priorite : basse | Fonctionnel
    ...
    ...    Etapes : login avec "Remember me" coche, logout, retour sur la page de login.
    ...    Resultat attendu : le champ email est pre-rempli.
    ...
    ...    *DEFAUT CONNU* : lors de l'analyse exploratoire, l'email n'est pas pre-rempli
    ...    (aucun cookie ni localStorage cree). Ce test est conserve en echec : un ecart
    ...    entre le comportement attendu et observe est un defaut a signaler, pas un
    ...    test a corriger.
    [Tags]    id-1003-B    functional    priority-low    level-system    known-defect
    Click Sign In Link
    Login Page Should Be Open
    Input Login Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Select Remember Me
    Submit Login Form
    Customers Page Should Be Open
    Click Sign Out Link
    Signed Out Page Should Be Open
    Click Sign In Link
    Login Page Should Be Open
    Email Field Should Be Prepopulated    ${VALID_EMAIL}

TC-1004 Should Be Able To Log Out
    [Documentation]    Cas 1004 | Niveau : systeme | Priorite : moyenne | Fonctionnel
    ...
    ...    Etapes : login valide, clic "Sign Out".
    ...    Resultat attendu : la page "Signed Out" se charge.
    ...    (Le cahier indique par erreur les mots-cles "Open Browser | Go To" pour
    ...    l'etape de logout ; on utilise un clic sur le lien.)
    [Tags]    id-1004    functional    priority-medium    level-system
    Login As Admin
    Click Sign Out Link
    Signed Out Page Should Be Open
