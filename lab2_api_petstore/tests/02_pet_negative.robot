*** Settings ***
Documentation     Etape 2 - Cas accidentels. Pour chaque cas : code attendu selon le contrat
...               Swagger vs code obtenu (journal : results/contract_check.csv).
...               Un ecart est un DEFAUT de l'API a signaler : le test est conserve en echec
...               (tag known-defect) et non "corrige" pour passer.
Resource          ../resources/petstore_api.resource
Suite Setup       Prepare Negative Suite
Test Setup        Prepare Unique Pet Id
Test Teardown     Cleanup Pet    ${PET_ID}
Test Tags         lab2    negative    contract


*** Keywords ***
Prepare Negative Suite
    Create Petstore Session
    Reset Contract Check Log    ${OUTPUT DIR}${/}contract_check.csv


*** Test Cases ***
TC-API-02 Get Non Existent Pet Should Return 404
    [Documentation]    GET /pet/{petId} avec un id inexistant. Contrat : 404 "Pet not found".
    [Tags]    id-api-02    priority-high
    ${response}=    Get Pet    ${PET_ID}
    Response Should Match Contract    TC-API-02    GET /pet/{id inexistant}    ${response}    404
    Should Be Equal As Strings    ${response.json()}[message]    Pet not found

TC-API-03 Get Pet With Non Numeric Id Should Return 400
    [Documentation]    GET /pet/abc. Contrat : 400 "Invalid ID supplied".
    ...    Observe lors de l'exploration : 404 avec un message "NumberFormatException"
    ...    (fuite d'une exception Java interne) -> DEFAUT.
    [Tags]    id-api-03    priority-medium    known-defect
    ${response}=    Get Pet    abc
    Response Should Match Contract    TC-API-03    GET /pet/abc    ${response}    400

TC-API-04 Create Pet With Malformed Json Should Return 405
    [Documentation]        ...    Observe : 500 "something bad happened" avec ce corps tronque (5 essais sur 5) ;
    ...    400 "bad input" avec un corps tronque plus court (sonde). Le code d'erreur
    ...    depend donc du corps ; un 500 trahit une erreur interne non geree.
    [Tags]    id-api-04    priority-medium    known-defect
    ${raw}=    Read Text File    ${MALFORMED_PET_BODY}
    ${response}=    Create Pet With Raw Body    ${raw}
    Response Should Match Contract    TC-API-04    POST /pet (JSON malforme)    ${response}    405

TC-API-05 Find By Status With Invalid Status Should Return 400
    [Documentation]    GET /pet/findByStatus?status=invalide. Contrat : 400 "Invalid status value".
    ...    Observe lors de l'exploration : 200 avec une liste vide -> DEFAUT (valeur invalide
    ...    acceptee sans erreur).
    [Tags]    id-api-05    priority-medium    known-defect
    ${response}=    Find Pets By Status    invalide
    Response Should Match Contract    TC-API-05    GET /pet/findByStatus?status=invalide    ${response}    400

TC-API-06 Delete Already Deleted Pet Should Return 404
    [Documentation]    DELETE d'un animal deja supprime. Contrat : 404 "Pet not found".
    [Tags]    id-api-06    priority-medium
    ${payload}=    Build Pet Payload    ${PET_TEMPLATE}    ${PET_ID}    Ephemere    available
    ${response}=    Create Pet    ${payload}
    Response Status Should Be    ${response}    200
    ${response}=    Delete Pet    ${PET_ID}
    Response Status Should Be    ${response}    200
    ${response}=    Delete Pet    ${PET_ID}
    Response Should Match Contract    TC-API-06    DELETE /pet/{id} (2e suppression)    ${response}    404

TC-API-07 Create Pet With Empty Body Should Return 405
    [Documentation]    POST /pet sans corps. Contrat : 405 "Invalid input".
    [Tags]    id-api-07    priority-low
    ${response}=    Create Pet With Raw Body    ${EMPTY}
    Response Should Match Contract    TC-API-07    POST /pet (corps vide)    ${response}    405
