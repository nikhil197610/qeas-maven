# Offline / No-GitHub Install

Some corporate/bank networks block `raw.githubusercontent.com`. You can still use the framework with
**no GitHub at build time** by installing the jar into your **local Maven repo** (`~/.m2/repository`).
Your project then resolves the framework from there; the transitive deps (Appium/Selenium/…) come from
**Maven Central** (or your internal Nexus/Artifactory mirror).

## Option A — GitHub reachable from your machine (download once)
```bash
# macOS / Linux / Git Bash
bash <(curl -fsSL https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/install-local.sh)
```
```powershell
# Windows PowerShell
iwr https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/install-local.ps1 -OutFile install-local.ps1
powershell -ExecutionPolicy Bypass -File .\install-local.ps1
```

## Option B — GitHub fully blocked (bring the jar yourself)
Get `framework-core-0.2.0.jar` (+ `.pom`) from a colleague / shared drive, then:
```bash
bash install-local.sh /path/framework-core-0.2.0.jar /path/framework-core-0.2.0.pom
```
```powershell
powershell -ExecutionPolicy Bypass -File .\install-local.ps1 -Jar C:\path\framework-core-0.2.0.jar -Pom C:\path\framework-core-0.2.0.pom
```
The script just copies the two files into
`~/.m2/repository/com/qeas/automation/framework-core/0.2.0/` — no Maven install needed.

## Then point the build at the local repo (no GitHub)
`build.gradle.kts`:
```kotlin
repositories {
    mavenLocal()      // framework-core comes from ~/.m2
    mavenCentral()    // transitive deps (Appium/Selenium/…); or your internal mirror
}
dependencies { testImplementation("com.qeas.automation:framework-core:0.2.0") }
```
`gradlew test` now builds without contacting GitHub.

## Fully air-gapped (Maven Central also blocked)
Point `mavenCentral()` at your organisation's mirror instead:
```kotlin
repositories {
    mavenLocal()
    maven { url = uri("https://nexus.yourbank.internal/repository/maven-central/") }
}
```
Ask your DevOps team for the internal mirror URL; the coordinates
(`com.qeas.automation:framework-core:0.2.0`) don't change.
