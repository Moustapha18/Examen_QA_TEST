"""Bibliotheque Robot Framework d'appui pour le Lab 2 (Petstore).

Fournit : id unique, construction de corps JSON depuis un modele, validation par schema
JSON (bibliotheque `jsonschema`) et journal CSV des verifications de contrat.
"""
import csv
import json
import os
import random
import time
from datetime import datetime
from string import Template

from jsonschema import Draft7Validator

_CSV_HEADER = ["horodatage", "cas", "requete", "code_attendu_contrat", "code_obtenu", "verdict", "corps_obtenu"]


def generate_unique_pet_id():
    """Id unique par execution : l'API est partagee par tous les utilisateurs."""
    return int(time.time() * 1000) * 1000 + random.randint(0, 999)


def build_pet_payload(template_path, pet_id, name, status="available"):
    """Construit le corps JSON d'un animal a partir du modele data/pet.json.tpl."""
    with open(template_path, encoding="utf-8") as handle:
        template = Template(handle.read())
    rendered = template.substitute(PET_ID=pet_id, PET_NAME=name, PET_STATUS=status)
    return json.loads(rendered)


def read_text_file(path):
    with open(path, encoding="utf-8") as handle:
        return handle.read()


def validate_json_against_schema(instance, schema_path):
    """Valide `instance` contre le schema ; liste toutes les violations."""
    with open(schema_path, encoding="utf-8") as handle:
        schema = json.load(handle)
    validator = Draft7Validator(schema)
    errors = sorted(validator.iter_errors(instance), key=lambda e: list(e.path))
    if errors:
        lines = [
            f"- {'/'.join(str(p) for p in e.path) or '<racine>'} : {e.message}" for e in errors
        ]
        raise AssertionError("Violations du schema JSON :\n" + "\n".join(lines))


def reset_contract_check_log(csv_path):
    """Recree le journal CSV (appele au debut de la suite)."""
    os.makedirs(os.path.dirname(csv_path), exist_ok=True)
    with open(csv_path, "w", newline="", encoding="utf-8") as handle:
        csv.writer(handle).writerow(_CSV_HEADER)


def record_contract_check(case, request, expected, obtained, body, csv_path):
    """Ajoute une ligne au journal et renvoie 'CONFORME' ou 'ECART'."""
    verdict = "CONFORME" if int(expected) == int(obtained) else "ECART"
    snippet = " ".join(str(body).split())[:120]
    if not os.path.exists(csv_path):
        reset_contract_check_log(csv_path)
    with open(csv_path, "a", newline="", encoding="utf-8") as handle:
        csv.writer(handle).writerow(
            [datetime.now().isoformat(timespec="seconds"), case, request, expected, obtained, verdict, snippet]
        )
    return verdict
