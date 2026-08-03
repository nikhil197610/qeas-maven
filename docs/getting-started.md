# Getting Started

## Prerequisites
- **JDK 17** (Temurin 17 recommended). Nothing else — the Gradle wrapper is included.
- **VS Code** with the **Extension Pack for Java** (gives Java language support, the Test Runner, and
  Gradle for Java), or IntelliJ/Eclipse. No separate Gradle install needed.
- No `gh`, no `winget`, no token.

Check Java: `java -version` should print 17. In VS Code you can install it via
`Ctrl+Shift+P → Java: Install New JDK → Temurin 17`.

## One-command setup (fresh project)
Creates a ready-to-run project with Mobile/Web/API/AS400 + a mixed example, the Gradle wrapper, and
runs the API suite.

**Windows / PowerShell (VS Code terminal):**
```powershell
iwr https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/setup.ps1 -OutFile setup.ps1
powershell -ExecutionPolicy Bypass -File .\setup.ps1 -Name eab-payments
```
**macOS / Linux / Git Bash:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/setup.sh) eab-payments
```
> On a locked-down network where GitHub is blocked, use the [Offline install](offline-install.md).

## Add to an existing project (no script)
`build.gradle.kts`:
```kotlin
repositories {
    mavenCentral()
    maven { url = uri("https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/") }
}
dependencies { testImplementation("com.qeas.automation:framework-core:0.2.0") }
tasks.test { useTestNG { suites("src/test/resources/testng.xml") } }
```
Register the listeners in `src/test/resources/testng.xml`:
```xml
<listeners>
    <listener class-name="com.qeas.automation.reporting.RetryListener"/>
    <listener class-name="com.qeas.automation.reporting.AllureListener"/>
</listeners>
```

## Run
```
gradlew test                    # API suite — green anywhere, no device/host
gradlew test -Psuite=mobile     # or: web | as400 | e2e | regression
```
In VS Code: **Trust** the folder if prompted (banner → Manage → Trust) so the Java extension leaves
"Restricted / Lightweight Mode"; then use the **Testing** panel (flask icon) to run tests with ▶.

## See the report
```
gradlew allureServe
```
