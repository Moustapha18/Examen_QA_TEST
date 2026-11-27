# Lab 2 - Analyse de l'API Swagger Petstore

Base : https://petstore.swagger.io/v2 - Observations : sonde exploratoire `tools/probe_petstore.py`
(resultats bruts : `docs/probe_petstore.txt`).

## 1. Scenario CRUD nominal (TC-API-01)

| Etape | Requete | Attendu | Observe |
|---|---|---|---|
| 1. Creer | POST /pet | 200, id/nom/statut renvoyes | 200, conforme |
| 2. Lire | GET /pet/{id} | 200, donnees identiques | 200, conforme |
| 3. Mettre a jour | PUT /pet puis GET | 200, modification confirmee | 200, conforme |
| 4. Supprimer | DELETE /pet/{id} | 200 | 200 (`message` = id) |
| 5. Verifier | GET /pet/{id} | 404 "Pet not found" | 404 "Pet not found" |

## 2. Cas accidentels : contrat Swagger vs comportement reel

Codes du contrat (spec Swagger 2.0 de Petstore) : POST /pet -> 405 ; GET et DELETE /pet/{petId}
-> 400 (id invalide), 404 (introuvable) ; GET /pet/findByStatus -> 400 (statut invalide).
**A verifier dans la Swagger UI officielle avant de rendre** (https://petstore.swagger.io).

| Cas | Requete | Code attendu (contrat) | Code obtenu | Verdict |
|---|---|---|---|---|
| TC-API-02 | GET /pet/{id inexistant} | 404 | 404 | Conforme |
| TC-API-03 | GET /pet/abc | 400 | 404 (message `NumberFormatException`) | **Defaut** |
| TC-API-04 | POST /pet, JSON malforme | 405 | 400 "bad input" | **Ecart** |
| TC-API-05 | GET /pet/findByStatus?status=invalide | 400 | 200 + liste vide | **Defaut** |
| TC-API-06 | DELETE d'un animal deja supprime | 404 | 404 (corps vide) | Conforme |
| TC-API-07 | POST /pet, corps vide | 405 | 405 "no data" | Conforme |

Commentaires :
- TC-API-03 : l'API repond 404 au lieu de 400 et **laisse fuiter une exception Java interne**
  (defaut de securite/qualite des messages d'erreur).
- TC-API-04 | POST /pet, JSON malforme | 405 | 500 "something bad happened" (corps tronque long, 5/5) ; 400 "bad input" (corps tronque court) | **Defaut** (incoherent) |
- TC-API-05 : une valeur hors enumeration (available/pending/sold) est acceptee sans erreur.
- Les 3 tests en ecart sont conserves en echec (tag `known-defect`) : un ecart est un defaut
  a signaler, pas un test a corriger.

## 3. Validation du contrat (TC-API-08, TC-API-09)

Schema `lab2_api_petstore/data/pet_schema.json` (jsonschema, Draft 7) : champs obligatoires
(`id`, `name`, `photoUrls` ; le contrat impose `name` et `photoUrls`), types, enumeration de
`status`. TC-API-09 verifie hors ligne que le schema detecte bien un statut interdit, un type
errone et un champ manquant (controle du controle).

## 4. Fiabilite (test flaky)

Petstore est une instance publique partagee et instable. Mesures prises : id unique par test,
nettoyage en Teardown (jamais bloquant), relecture limitee a 3 tentatives apres ecriture
(coherence a terme). `tools/mock_petstore.py` est un double local reproduisant les reponses
observees : il valide la logique des tests hors ligne, mais n'est pas le vrai service.
Il illustre le besoin d'un environnement de test maitrise.
