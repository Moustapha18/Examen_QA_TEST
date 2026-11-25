"""Variables d'environnement du Lab 1 (Customer Service CRM).

Toute valeur peut etre surchargee en ligne de commande, par exemple :
    robot -v BROWSER:firefox -v HEADLESS:True lab1_ui_crm/tests
"""

# --- Application sous test -------------------------------------------------
BASE_URL = "https://automationplayground.com/crm"
HOME_URL = f"{BASE_URL}/index.html"

# Identifiants de l'application de demonstration publique (cf. enonce de l'examen).
VALID_EMAIL = "admin@robotframeworktutorial.com"
VALID_PASSWORD = "pwd"

# --- Navigateur ------------------------------------------------------------
BROWSER = "chrome"
HEADLESS = False                 # True pour une execution sans fenetre (CI)
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

# --- Synchronisation (cf. keywords "Set Selenium Speed / Timeout" du cahier)
SELENIUM_TIMEOUT = "10 seconds"
SELENIUM_SPEED = "0 seconds"
