"""Faux serveur Petstore LOCAL qui reproduit les comportements observes par la sonde.

Usage (environnement maitrise, utile pour valider les tests hors ligne) :
    python tools/mock_petstore.py            # ecoute sur http://127.0.0.1:8099/v2
    robot -v BASE_URL:http://127.0.0.1:8099/v2 lab2_api_petstore/tests

ATTENTION : ce n'est PAS le vrai Petstore. Il ne prouve que la logique des tests.
Les ecarts au contrat (400 vs 405, 404 vs 400, 200 vs 400) sont reproduits a l'identique
de ce qui a ete observe sur petstore.swagger.io.
"""
import json
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, urlparse

PETS = {}


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *args):
        pass

    def _send(self, code, body=None):
        raw = b"" if body is None else json.dumps(body, separators=(",", ":")).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(raw)))
        self.end_headers()
        self.wfile.write(raw)

    def _body(self):
        n = int(self.headers.get("Content-Length") or 0)
        return self.rfile.read(n) if n else b""

    def _save(self):
        raw = self._body()
        if not raw:
            return self._send(405, {"code": 405, "type": "unknown", "message": "no data"})
        try:
            pet = json.loads(raw)
        except ValueError:
            return self._send(400, {"code": 400, "type": "unknown", "message": "bad input"})
        PETS[int(pet["id"])] = pet
        self._send(200, pet)

    def do_POST(self):
        if urlparse(self.path).path == "/v2/pet":
            self._save()
        else:
            self._send(404, {})

    def do_PUT(self):
        self._save()

    def do_GET(self):
        url = urlparse(self.path)
        if url.path == "/v2/pet/findByStatus":
            wanted = parse_qs(url.query).get("status", [])
            return self._send(200, [p for p in PETS.values() if p.get("status") in wanted])
        pet_id = url.path.rsplit("/", 1)[-1]
        try:
            pet = PETS.get(int(pet_id))
        except ValueError:
            return self._send(404, {"code": 404, "type": "unknown",
                                    "message": f'java.lang.NumberFormatException: For input string: "{pet_id}"'})
        if pet is None:
            return self._send(404, {"code": 1, "type": "error", "message": "Pet not found"})
        self._send(200, pet)

    def do_DELETE(self):
        pet_id = self.path.rsplit("/", 1)[-1]
        try:
            existed = PETS.pop(int(pet_id), None)
        except ValueError:
            return self._send(404)
        if existed is None:
            return self._send(404)
        self._send(200, {"code": 200, "type": "unknown", "message": pet_id})


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8099
    print(f"Mock Petstore sur http://127.0.0.1:{port}/v2")
    ThreadingHTTPServer(("127.0.0.1", port), Handler).serve_forever()
