# QEAS Automation Framework — public binary feed

This public repo serves the compiled `com.qeas.automation:framework-core` jar as a **raw-Maven repo**.
It contains **only the obfuscated binary** (public API kept, internals renamed, debug info stripped) —
**no source**. The framework source is private. Consuming it needs **no login and no token**.

**Current version: `0.2.0`.**

📖 **Guidance docs:** [docs/](docs/) — [Getting Started](docs/getting-started.md) ·
[Project Structure](docs/project-structure.md) · [Engines](docs/engines.md) ·
[Offline / No-GitHub install](docs/offline-install.md) · [Troubleshooting](docs/troubleshooting.md).

---

## Use it in a project (one line, no credentials)
Add to your `build.gradle.kts`:
```kotlin
repositories {
    mavenCentral()
    maven { url = uri("https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/") }
}
dependencies {
    testImplementation("com.qeas.automation:framework-core:0.2.0")
}
tasks.test { useTestNG { suites("src/test/resources/testng.xml") } }
```
Register the framework listeners in `src/test/resources/testng.xml`:
```xml
<listeners>
    <listener class-name="com.qeas.automation.reporting.RetryListener"/>
    <listener class-name="com.qeas.automation.reporting.AllureListener"/>
</listeners>
```
Then `./gradlew test` (Windows: `gradlew.bat test`). Everything — Appium, Selenium, REST Assured,
TestNG, Allure — resolves automatically from Maven Central.

## Fresh project in one command (needs only a JDK 17)
**Windows / PowerShell (VS Code terminal):**
```powershell
iwr https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/setup.ps1 -OutFile setup.ps1
powershell -ExecutionPolicy Bypass -File .\setup.ps1 -Name eab-payments
```
**macOS / Linux / Git Bash:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/setup.sh) eab-payments
```
It scaffolds a **ready-to-run project with Mobile, Web, API, AS/400 and a mixed (cross-engine) example**
(plus the Gradle wrapper) and runs the API suite. Browse it first at
[`examples/eab-payments`](examples/eab-payments).

## Folder structure — how to manage all four engines + mixed flows
Organise **by engine** (each engine keeps its own page objects/tests), with a top-level `e2e/` for
scenarios that cross engines. Locators stay in JSON, config per engine, one TestNG suite per engine:
```
src/test/
  java/com/arabbank/eab/payments/
    support/ BaseTest.java                        # project base: extends BaseMobileTest, loads testdata
    mobile/                                       # Appium
       screens/common/  LoginScreen.java HomeScreen.java   # page objects — extend BaseScreen
       flows/           LoginFlow.java                     # reusable multi-screen flows
       data/            LoginData.java                      # data records built from testdata.yaml
       tests/           LoginMobileTest.java                # data-driven test (BaseTest + flow + data)
    web/                                          # Selenium
       pages/  LoginPage.java                     # extend BasePage
       tests/  LoginWebTest.java
    api/     tests/AccountApiTest.java            # REST Assured — ApiClient
    as400/   tests/BackendChecksAs400Test.java    # JTOpen AS400System / AS400Client (+HaclTerminal on ACS)
    e2e/     tests/TransferThenVerifyE2ETest.java # MIXED: mobile action -> verify via API + AS/400
  resources/
    config/    android.yaml ios.yaml browserstack.yaml web.yaml api.yaml as400.yaml testdata.yaml
    locators/  common/LoginScreen.json            # JSON locators, grouped by feature module
    suites/    mobile.xml web.xml api.xml as400.xml e2e.xml regression.xml
    testng.xml                                    # default = API (green anywhere)
```
Same shape as the real EAB project: **page objects** per screen, **flows** composing them, **data**
records from `testdata.yaml`, a project **BaseTest**, config per engine, JSON locators. Add a screen →
add its locator JSON; add a scenario → add a flow + a data record + a test.
**Run a specific engine:**
```
gradlew test                    # API suite (default, no device/host needed)
gradlew test -Psuite=mobile     # or web | as400 | e2e | regression
```
A **mixed** test just extends `BaseMobileTest` (for the mobile part) and, in the same method, calls
`ApiClient` and `AS400System` to verify the backend — see `e2e/TransferThenVerifyE2ETest.java`.

## What each engine gives you
- **Mobile** — `DriverFactory` + `BaseScreen` (one `click()`, waits, gestures, self-healing).
- **Web** — `BasePage` + `BrowserActions` (Selenium 4).
- **API** — `ApiClient` / `ApiResponse` / `ApiAuth` (auth incl. OAuth2, retry, JSON-schema, Allure).
- **AS/400** — `AS400Client` (JDBC), `AS400System` (CL + program calls), `HaclTerminal` (headless 5250).
