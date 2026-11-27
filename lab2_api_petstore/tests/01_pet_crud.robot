*** Settings ***
Documentation     Etape 1 - Scenario CRUD nominal : cycle de vie complet d'un animal.
Resource          ../resources/petstore_api.resource
Suite Setup       Create Petstore Session
Test Setup        Prepare Unique Pet Id
Test Teardown     Cleanup Pet    ${PET_ID}
Test Tags         lab2    crud


*** Test Cases ***
TC-API-01 Pet Lifecycle Should Work End To End
    [Documentation]    Creer, lire, mettre a jour, supprimer puis verifier la suppression.
    [Tags]    id-api-01    smoke    priority-high
    ${payload}=    Build Pet Payload    ${PET_TEMPLATE}    ${PET_ID}    Rex    available

    # Etape 1 - Creer : 200, le corps renvoie l'id, le nom et le statut envoyes
    ${response}=    Create Pet    ${payload}
    Response Status Should Be    ${response}    200
    Pet Body Should Match    ${response}    ${PET_ID}    Rex    available

    # Etape 2 - Lire : 200, donnees identiques a la creation
    ${response}=    Get Pet Expecting Status    ${PET_ID}    200
    Dictionaries Should Be Equal    ${response.json()}    ${payload}

    # Etape 3 - Mettre a jour : nom modifie, statut "sold" ; un nouveau GET confirme
    ${updated}=    Build Pet Payload    ${PET_TEMPLATE}    ${PET_ID}    Rex Updated    sold
    ${response}=    Update Pet    ${updated}
    Response Status Should Be    ${response}    200
    Pet Body Should Match    ${response}    ${PET_ID}    Rex Updated    sold
    ${response}=    Get Pet Expecting Status    ${PET_ID}    200
    Pet Body Should Match    ${response}    ${PET_ID}    Rex Updated    sold

    # Etape 4 - Supprimer : 200
    ${response}=    Delete Pet    ${PET_ID}
    Response Status Should Be    ${response}    200
    Should Be Equal As Strings    ${response.json()}[message]    ${PET_ID}

    # Etape 5 - Verifier : 404 et message "Pet not found"
    ${response}=    Get Pet Expecting Status    ${PET_ID}    404
    Should Be Equal As Strings    ${response.json()}[message]    Pet not found
