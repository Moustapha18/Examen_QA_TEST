*** Settings ***
Documentation     Mots-cles du Lab 2 : un mot-cle reutilisable par operation de l'API
...               (Create Pet, Get Pet, Update Pet, Delete Pet, Find Pets By Status),
...               plus les verifications communes.
Library           RequestsLibrary
Library           Collections
Library           ../libraries/PetstoreSupport.py
Variables         ../variables/env.py


*** Keywords ***
# ------------------------------------------------------------------ Session
Create Petstore Session
    Create Session    ${SESSION_ALIAS}    ${BASE_URL}    headers=${HEADERS}    timeout=${REQUEST_TIMEOUT}    verify=${TRUE}

Prepare Unique Pet Id
    [Documentation]    Test Setup : id unique par test (l'API est partagee par tous).
    ${pet_id}=    Generate Unique Pet Id
    Set Test Variable    ${PET_ID}    ${pet_id}

Cleanup Pet
    [Documentation]    Test Teardown : supprime l'animal du test, quel que soit le resultat.
    ...                Le resultat du nettoyage est journalise mais n'echoue jamais le test.
    [Arguments]    ${pet_id}
    ${status}    ${result}=    Run Keyword And Ignore Error    Delete Pet    ${pet_id}
    IF    '${status}' == 'PASS'
        Log    Nettoyage DELETE /pet/${pet_id} -> ${result.status_code}
    ELSE
        Log    Nettoyage impossible pour ${pet_id} : ${result}    WARN
    END

# --------------------------------------------------------------- Operations
# expected_status=anything : les mots-cles ne jugent pas le code HTTP ; ce sont les
# tests qui l'affirment (necessaire pour comparer au contrat dans les cas negatifs).
Create Pet
    [Arguments]    ${payload}
    ${response}=    POST On Session    ${SESSION_ALIAS}    /pet    json=${payload}    expected_status=anything
    RETURN    ${response}

Create Pet With Raw Body
    [Documentation]    Envoie un corps brut (JSON malforme, corps vide...).
    [Arguments]    ${raw_body}
    ${response}=    POST On Session    ${SESSION_ALIAS}    /pet    data=${raw_body}    expected_status=anything
    RETURN    ${response}

Get Pet
    [Arguments]    ${pet_id}
    ${response}=    GET On Session    ${SESSION_ALIAS}    /pet/${pet_id}    expected_status=anything
    RETURN    ${response}

Update Pet
    [Arguments]    ${payload}
    ${response}=    PUT On Session    ${SESSION_ALIAS}    /pet    json=${payload}    expected_status=anything
    RETURN    ${response}

Delete Pet
    [Arguments]    ${pet_id}
    ${response}=    DELETE On Session    ${SESSION_ALIAS}    /pet/${pet_id}    expected_status=anything
    RETURN    ${response}

Find Pets By Status
    [Arguments]    ${status}
    ${response}=    GET On Session    ${SESSION_ALIAS}    /pet/findByStatus    params=status=${status}    expected_status=anything
    RETURN    ${response}

# ----------------------------------------------------------- Relecture tolerante
Get Pet Expecting Status
    [Documentation]    Relecture apres ecriture avec au plus 3 tentatives. Petstore est une instance
    ...                publique repartie sur plusieurs serveurs : une lecture immediate peut ne
    ...                pas refleter l'ecriture (coherence a terme). Chaque tentative est journalisee.
    [Arguments]    ${pet_id}    ${expected_status}
    ${response}=    Wait Until Keyword Succeeds    ${READ_RETRIES}    ${READ_RETRY_DELAY}
    ...    Get Pet And Check Status    ${pet_id}    ${expected_status}
    RETURN    ${response}

Get Pet And Check Status
    [Arguments]    ${pet_id}    ${expected_status}
    ${response}=    Get Pet    ${pet_id}
    Log    GET /pet/${pet_id} -> ${response.status_code}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    RETURN    ${response}

# ----------------------------------------------------------------- Assertions
Response Status Should Be
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    ...    msg=Code HTTP attendu ${expected_status}, obtenu ${response.status_code} (corps : ${response.text})

Pet Body Should Match
    [Documentation]    Verifie id, nom et statut dans le corps de la reponse.
    [Arguments]    ${response}    ${expected_id}    ${expected_name}    ${expected_status}
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${body}[id]    ${expected_id}
    Should Be Equal As Strings     ${body}[name]    ${expected_name}
    Should Be Equal As Strings     ${body}[status]    ${expected_status}

Response Should Match Contract
    [Documentation]    Compare le code obtenu au code attendu par le contrat Swagger, journalise
    ...                la comparaison (results/contract_check.csv) puis echoue en cas d'ecart.
    ...                Un ecart est un DEFAUT a signaler, pas un test a corriger.
    [Arguments]    ${case}    ${request}    ${response}    ${contract_status}
    ${verdict}=    Record Contract Check    ${case}    ${request}    ${contract_status}
    ...    ${response.status_code}    ${response.text}    ${OUTPUT DIR}${/}contract_check.csv
    Log To Console    \nCONTRAT : ${case} | ${request} | attendu=${contract_status} | obtenu=${response.status_code} | ${verdict}
    Should Be Equal As Integers    ${response.status_code}    ${contract_status}
    ...    msg=ECART AVEC LE CONTRAT Swagger : attendu ${contract_status}, obtenu ${response.status_code} (corps : ${response.text})
