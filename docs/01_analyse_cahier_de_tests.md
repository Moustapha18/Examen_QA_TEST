# Lab 1 - Analyse du cahier de tests "Customer Service Test Cases"

Application : https://automationplayground.com/crm/index.html

## 1. Classification des cas

Le cahier fournit l'Id, la fonction et le type (Smoke / Functional). Le **niveau** et la
**priorite** ne figurent pas dans le cahier : ils sont proposes ici (hypotheses d'analyse).

| Id | Cas | Fonction | Niveau | Priorite | Smoke |
|---|---|---|---|---|---|
| 1001 | Home page should load | Home | Systeme | Haute | Oui |
| 1002 | Login should succeed with valid credentials | Login | Systeme | Haute | Oui |
| 1003-A | Login should fail with missing credentials | Login | Systeme | Moyenne | Non |
| 1003-B | "Remember me" should persist email address | Login | Systeme | Basse | Non |
| 1004 | Should be able to log out | Login | Systeme | Moyenne | Non |
| 1005 | Customers page should display multiple customers | Contacts | Systeme | Haute | Oui |
| 1006 | Should be able to add new customer | Contacts | Acceptation | Haute | Oui |
| 1007 | Should be able to cancel adding new customer | Contacts | Systeme | Basse | Non |

Justification des niveaux : tous les cas pilotent l'application complete via l'interface dans un
navigateur reel (niveau systeme). Le cas 1006 est classe en acceptation car il valide le
parcours metier principal du CRM de bout en bout (user story "ajouter un client").
Suite smoke : 1001, 1002, 1005, 1006 (chemin critique : ouvrir, se connecter, lister, creer).

## 2. Anomalies relevees dans le cahier

1. Id 1003 utilise pour deux cas differents -> suffixes -A et -B.
2. Cas 1001 : resultat attendu vague ("per requirements") -> defini apres inspection de la page.
3. Cas 1004 : mots-cles "Open Browser | Go To" copies par erreur sur l'etape de logout.
4. Cas 1003-A : etape "Log that we are skipping credentials?" formulee comme une question.
5. Cas 1005 : "Challenge: how will we test this?" -> comptage des lignes de donnees de la grille.
6. Incoherence 1006/1007 : login en pre-condition (1006) ou dans les etapes (1007).
7. Plusieurs etapes de saisie sans resultat attendu.

## 3. Observations issues de l'analyse exploratoire

| # | Observation | Gravite |
|---|---|---|
| O1 | "Remember me" : apres logout, l'email n'est pas pre-rempli, aucun cookie/localStorage cree. Ecart avec le cahier (cas 1003-B). | Defaut fonctionnel |
| O2 | Apres le login, l'URL contient `?email-name=...&password-name=pwd` : identifiants en clair dans l'URL (formulaire en GET). | Defaut de securite |
| O3 | Login vide : validation uniquement cote navigateur (HTML5 `required`), aucun message applicatif. | Observation |
| O4 | Apres ajout, le client n'apparait pas dans la grille (6 lignes avant et apres). | Observation |
| O5 | Lien "Cancel" : un clic intercepte a ete observe sur une execution (non reproduit ensuite). | Fiabilite des tests |
| O6 | Le lien "Sign In" n'a un id que sur la page d'accueil ; zone de texte sans id/name dans la barre de navigation. | Testabilite |

## 4. Resultat attendu de l'execution

7 cas passent ; **TC-1003-B est attendu en echec** (defaut O1 confirme).
