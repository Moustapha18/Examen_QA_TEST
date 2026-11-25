"""Inspection v4 : fenetre 1920x1080, diagnostic remember-me, parcours d'ajout."""
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select

BASE = "https://automationplayground.com/crm/"
USER = "admin@robotframeworktutorial.com"
PWD = "pwd"

options = webdriver.ChromeOptions()
options.add_argument("--window-size=1920,1080")
driver = webdriver.Chrome(options=options)
driver.implicitly_wait(5)
print("viewport:", driver.execute_script("return [innerWidth, innerHeight]"))


def do(label, fn):
    try:
        fn()
        print(f"  OK   {label}")
    except Exception as e:
        print(f"  KO   {label} -> {type(e).__name__}: {str(e).splitlines()[0]}")


def login(remember=False):
    driver.get(BASE + "login.html")
    driver.find_element(By.ID, "email-id").send_keys(USER)
    driver.find_element(By.ID, "password").send_keys(PWD)
    if remember:
        driver.find_element(By.ID, "remember").click()
    driver.find_element(By.ID, "submit-id").click()


print("\n===== B. REMEMBER ME (diagnostic) =====")
login(remember=True)
print("  cookies:", driver.get_cookies())
print("  localStorage:", driver.execute_script("return JSON.stringify(window.localStorage)"))
driver.find_element(By.LINK_TEXT, "Sign Out").click()
print("  cookies apres logout:", driver.get_cookies())
driver.find_element(By.LINK_TEXT, "Sign In").click()
print("  email-id =", repr(driver.find_element(By.ID, "email-id").get_attribute("value")))
print("  remember coche =", driver.find_element(By.ID, "remember").is_selected())

print("\n===== C. AJOUT CLIENT =====")
login()
driver.find_element(By.ID, "new-customer").click()
do("email", lambda: driver.find_element(By.ID, "EmailAddress").send_keys("qa.test@example.com"))
do("prenom", lambda: driver.find_element(By.ID, "FirstName").send_keys("Moussa"))
do("nom", lambda: driver.find_element(By.ID, "LastName").send_keys("Testeur"))
do("ville", lambda: driver.find_element(By.ID, "City").send_keys("Dakar"))
do("etat", lambda: Select(driver.find_element(By.ID, "StateOrRegion")).select_by_value("NY"))
do("genre", lambda: driver.find_element(By.CSS_SELECTOR, "input[name='gender'][value='male']").click())
do("promo", lambda: driver.find_element(By.NAME, "promos-name").click())
do("submit", lambda: driver.find_element(By.CSS_SELECTOR, "button[type='submit']").click())
print("  URL apres submit:", driver.current_url)
print("  texte page:", driver.find_element(By.TAG_NAME, "body").text[:300].replace("\n", " | "))
for l in driver.find_elements(By.TAG_NAME, "a"):
    if l.is_displayed():
        print(f"  lien: '{l.text.strip()}' -> {l.get_attribute('href')}")
driver.get(BASE + "customers.html")
rows = driver.find_elements(By.XPATH, "//table//tr[td]")
print(f"  GRILLE: {len(rows)} lignes de donnees")
for r in rows:
    print("   ", r.text.replace("\n", " "))

print("\n===== D. CANCEL (clic normal, fenetre 1920x1080) =====")
driver.find_element(By.ID, "new-customer").click()
do("cancel", lambda: driver.find_element(By.LINK_TEXT, "Cancel").click())
print("  URL apres cancel:", driver.current_url)
driver.quit()