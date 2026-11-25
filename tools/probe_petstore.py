"""Sonde exploratoire de l'API Petstore : codes et corps reels pour les cas du Lab 2."""
import time
import requests

BASE = "https://petstore.swagger.io/v2"
H = {"Content-Type": "application/json", "Accept": "application/json"}
PET_ID = int(time.time())
pet = {"id": PET_ID, "name": "Rex", "status": "available",
       "category": {"id": 1, "name": "dogs"}, "photoUrls": ["http://x/y.png"],
       "tags": [{"id": 1, "name": "friendly"}]}


def call(label, method, path, **kw):
    try:
        r = requests.request(method, BASE + path, headers=H, timeout=20, **kw)
        print(f"\n[{label}] {method} {path} -> {r.status_code}")
        print("   corps:", r.text[:250].replace("\n", " "))
    except Exception as e:
        print(f"\n[{label}] {method} {path} -> EXCEPTION {type(e).__name__}: {e}")


call("1 create", "POST", "/pet", json=pet)
call("2 read", "GET", f"/pet/{PET_ID}")
call("3 update", "PUT", "/pet", json={**pet, "name": "Rex2", "status": "sold"})
call("3b re-read", "GET", f"/pet/{PET_ID}")
call("4 delete", "DELETE", f"/pet/{PET_ID}")
call("5 read deleted", "GET", f"/pet/{PET_ID}")
call("N1 delete deja supprime", "DELETE", f"/pet/{PET_ID}")
call("N2 id inexistant", "GET", "/pet/999999999999")
call("N3 id non numerique", "GET", "/pet/abc")
call("N4 json malforme", "POST", "/pet", data='{"id": 1, "name": ')
call("N5 statut invalide", "GET", "/pet/findByStatus", params={"status": "invalide"})
call("N6 corps vide", "POST", "/pet", data="")
call("N7 id negatif", "GET", "/pet/-5")