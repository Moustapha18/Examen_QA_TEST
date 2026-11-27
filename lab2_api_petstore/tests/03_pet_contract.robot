*** Settings ***
Documentation     Etape 3 - Validation du contrat : structure de GET /pet/{petId} controlee
...               par un schema JSON (champs obligatoires, types, valeurs de status).
Resource          ../resources/petstore_api.resource
Suite Setup       Create Petstore Session
Test Setup        Prepare Unique Pet Id
Test Teardown     Cleanup Pet    ${PET_ID}
Test Tags         lab2    contract


*** Test Cases ***
TC-API-08 Get Pet Response Should Match Json Schema
    [Documentation]    Cree un animal, le relit et valide la reponse contre data/pet_schema.json.
    [Tags]    id-api-08    priority-high    schema
    ${payload}=    Build Pet Payload    ${PET_TEMPLATE}    ${PET_ID}    SchemaDog    pending
    ${response}=    Create Pet    ${payload}
    Response Status Should Be    ${response}    200
    ${response}=    Get Pet Expecting Status    ${PET_ID}    200
    Validate Json Against Schema    ${response.json()}    ${PET_SCHEMA}

TC-API-09 Json Schema Should Reject Invalid Pet
    [Documentation]    Controle du controle : le schema doit detecter un status interdit, un type
    ...    errone et un champ obligatoire manquant (aucun appel reseau).
    [Tags]    id-api-09    priority-medium    schema    offline
    ${invalid}=    Create Dictionary    id=not-a-number    name=Bad    status=unknown
    ${message}=    Run Keyword And Expect Error    *    Validate Json Against Schema    ${invalid}    ${PET_SCHEMA}
    Should Contain    ${message}    status
    Should Contain    ${message}    id
    Should Contain    ${message}    photoUrls
