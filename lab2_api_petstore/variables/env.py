"""Variables du Lab 2 (API Swagger Petstore) : URL de base, en-tetes, chemins de donnees.

Surcharge possible en ligne de commande, par exemple pour viser un autre environnement :
    robot -v BASE_URL:http://127.0.0.1:8099/v2 lab2_api_petstore/tests
"""
import os

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# --- API sous test ---------------------------------------------------------
BASE_URL = "https://petstore.swagger.io/v2"
SESSION_ALIAS = "petstore"
REQUEST_TIMEOUT = 20

HEADERS = {
    "Content-Type": "application/json",
    "Accept": "application/json",
}

# --- Donnees (modeles et schema) ------------------------------------------
DATA_DIR = os.path.join(_ROOT, "data")
PET_TEMPLATE = os.path.join(DATA_DIR, "pet.json.tpl")
PET_SCHEMA = os.path.join(DATA_DIR, "pet_schema.json")
MALFORMED_PET_BODY = os.path.join(DATA_DIR, "pet_malformed.txt")

# --- Politique de relecture (instance publique, coherence a terme) ---------
READ_RETRIES = "3x"
READ_RETRY_DELAY = "1 second"
