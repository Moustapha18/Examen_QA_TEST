"""Diagnostic v2 : identifie l'etape qui echoue et l'element au point bloque."""
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select

BASE = "https://automationplayground.com/crm/"

INFO_JS = """
var el = arguments[0];
var r = el.getBoundingClientRect();
var cx = r.left + r.width/2, cy = r.top + r.height/2;
var top = document.elementFromPoint(cx, cy);
var blk = document.elementFromPoint(463, 546);
return {
  target: el.outerHTML.substring(0, 120),
  rect: [Math.round(r.left), Math.round(r.top), Math.round(r.width), Math.round(r.height)],
  viewport: [innerWidth, innerHeight], scrollY: Math.round(scrollY),
  top_at_target_center: top ? top.outerHTML.substring(0, 120) : null,
  element_at_463_546: blk ? blk.outerHTML.substring(0, 120) : null
};
"""


def run(i):
    opts = webdriver.ChromeOptions()
    opts.add_argument("--window-size=1920,1080")
    d = webdriver.Chrome(options=opts)
    d.maximize_window()
    d.implicitly_wait(5)
    print(f"\n===== ESSAI {i} =====")

    def act(label, locate, action):
        el = locate()
        try:
            action(el)
            print(f"  OK  {label}")
        except Exception as e:
            print(f"  KO  {label} -> {str(e).splitlines()[0]}")
            print("      detail:", d.execute_script(INFO_JS, el))
            raise

    try:
        d.get(BASE + "login.html")
        d.find_element(By.ID, "email-id").send_keys("admin@robotframeworktutorial.com")
        d.find_element(By.ID, "password").send_keys("pwd")
        d.find_element(By.ID, "submit-id").click()
        d.find_element(By.ID, "new-customer").click()
        d.find_element(By.ID, "EmailAddress").send_keys(f"qa.{int(time.time())}@example.com")
        d.find_element(By.ID, "FirstName").send_keys("Moussa")
        d.find_element(By.ID, "LastName").send_keys("Testeur")
        d.find_element(By.ID, "City").send_keys("Dakar")
        print("  viewport au chargement:", d.execute_script("return [innerWidth, innerHeight]"))
        act("liste etat", lambda: d.find_element(By.ID, "StateOrRegion"),
            lambda el: Select(el).select_by_value("NY"))
        act("radio genre", lambda: d.find_element(By.CSS_SELECTOR, "input[name='gender'][value='male']"),
            lambda el: el.click())
        act("case promo", lambda: d.find_element(By.NAME, "promos-name"), lambda el: el.click())
        act("submit", lambda: d.find_element(By.CSS_SELECTOR, "button[type='submit']"),
            lambda el: el.click())
    except Exception:
        pass
    finally:
        d.quit()


for n in range(1, 5):
    run(n)