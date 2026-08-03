# QEAS Automation Framework — public binary feed

This public repo serves the compiled `com.qeas.automation:framework-core` jar as a **raw-Maven repo**.
It contains **only the obfuscated binary** (public API kept, internals renamed, debug info stripped) —
**no source**. The framework source is private. Consuming it needs **no login and no token**.

**Current version: `0.2.0`.**

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
It scaffolds a ready-to-run Gradle+TestNG project (with the Gradle wrapper) and runs the smoke test.

## What each engine gives you
- **Mobile** — `DriverFactory` + `BaseScreen` (one `click()`, waits, gestures, self-healing).
- **Web** — `BasePage` + `BrowserActions` (Selenium 4).
- **API** — `ApiClient` / `ApiResponse` / `ApiAuth` (auth incl. OAuth2, retry, JSON-schema, Allure).
- **AS/400** — `AS400Client` (JDBC), `AS400System` (CL + program calls), `HaclTerminal` (headless 5250).
