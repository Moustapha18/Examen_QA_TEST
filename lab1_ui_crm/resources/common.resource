*** Settings ***
Documentation     Mots-cles techniques communs : ouverture/fermeture du navigateur.
...               Correspond aux PRE-CONDITIONS et POST-CONDITIONS du cahier de tests
...               (ouvrir le navigateur, aller a la page d'accueil, fermer le navigateur).
Library           SeleniumLibrary
Variables         ../variables/env.py
Variables         ../data/test_data.py


*** Keywords ***
Open CRM Browser
    [Documentation]    Pre-condition : ouvre le navigateur configure et charge la page d'accueil.
    ${headless}=    Convert To Boolean    ${HEADLESS}
    ${options}=    Set Variable    add_argument("--window-size=${WINDOW_WIDTH},${WINDOW_HEIGHT}")
    IF    $headless
        ${options}=    Set Variable    ${options};add_argument("--headless=new")
    END
    Open Browser    ${HOME_URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}
    Set Selenium Speed    ${SELENIUM_SPEED}

Close CRM Browser
    [Documentation]    Post-condition : ferme tous les navigateurs ouverts.
    Close All Browsers

Scroll Element To Center
    [Documentation]    Place l'element au centre de la zone visible. Evite qu'un element
    ...                reste coupe en bas d'une petite fenetre (viewport observe : 1280x533
    ...                malgre --window-size=1920,1080).
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].scrollIntoView({block: 'center'});    ARGUMENTS    ${element}

Click Link When Ready
    [Documentation]    Clic robuste sur un lien : attend la visibilite, centre l'element,
    ...                puis reessaie si le clic est intercepte par un autre element.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Wait Until Keyword Succeeds    3x    1 second    Scroll Then Click Link    ${locator}

Click Button When Ready
    [Documentation]    Clic robuste sur un bouton (meme principe que Click Link When Ready).
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Wait Until Keyword Succeeds    3x    1 second    Scroll Then Click Button    ${locator}

Select Radio Button When Ready
    [Documentation]    Selection robuste d'un bouton radio : centre l'element puis reessaie.
    ...                Un "ElementClickInterceptedException" intermittent (environ 1 execution
    ...                sur 2) a ete observe sur les radios/cases du formulaire Add Customer.
    [Arguments]    ${group}    ${value}
    Wait Until Keyword Succeeds    5x    1 second    Scroll Then Select Radio Button    ${group}    ${value}

Select Checkbox When Ready
    [Documentation]    Selection robuste d'une case a cocher (meme principe).
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Wait Until Keyword Succeeds    5x    1 second    Scroll Then Select Checkbox    ${locator}

Scroll Then Click Link
    [Arguments]    ${locator}
    Scroll Element To Center    ${locator}
    Click Link    ${locator}

Scroll Then Click Button
    [Arguments]    ${locator}
    Scroll Element To Center    ${locator}
    Click Button    ${locator}

Scroll Then Select Radio Button
    [Arguments]    ${group}    ${value}
    Scroll Element To Center    css:input[name='${group}'][value='${value}']
    Select Radio Button    ${group}    ${value}

Scroll Then Select Checkbox
    [Arguments]    ${locator}
    Scroll Element To Center    ${locator}
    Select Checkbox    ${locator}
