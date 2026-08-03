# Troubleshooting

| Symptom | Cause / Fix |
|--------|-------------|
| `'gh' / 'winget' is not recognized` | You don't need them — the public feed needs no login. Use the [setup script](getting-started.md) or the manual `maven{}` snippet. |
| `Could not GET '…/framework-core-0.2.0.pom'` / connection blocked | Your network blocks `raw.githubusercontent.com`. Use the [Offline install](offline-install.md). |
| VS Code: **Restricted Mode** / **Java: Lightweight Mode** | Click the banner → **Manage → Trust folder**. The Java extension then loads fully (IntelliSense, Testing panel ▶). |
| `JAVA_HOME is not set` / `no java` when running `gradlew` | Install **JDK 17** (VS Code: `Ctrl+Shift+P → Java: Install New JDK → Temurin 17`), reopen the terminal. |
| First `gradlew` run is slow | It downloads Gradle 8.10 + all deps once, then caches them. Subsequent runs are fast. |
| Mobile suite fails with driver/session errors | `-Psuite=mobile` needs a real Appium device or BrowserStack. Fill `config/android.yaml` / `config/browserstack.yaml` and export `BROWSERSTACK_USER` / `BROWSERSTACK_KEY`. The **API** suite (default) needs none of this. |
| `locate("…")` fails at runtime | The element isn't in that screen's locator JSON, or the resource-id/xpath is wrong. Add/verify it in `resources/locators/<module>/<Screen>.json` against a live device. |
| `ClassNotFoundException: com.qeas.automation.mainframe.HaclTerminal` | The headless 5250 client isn't in the public jar (needs IBM ACS `acshod2.jar`). Use `AS400System`/`AS400Client`, or build the framework with `acshod2.jar` on an ACS machine. |
| Listener class not found from `testng.xml` | Ensure the dependency resolved and the names are exact: `com.qeas.automation.reporting.RetryListener` / `AllureListener`. |
| Tapping a button "does nothing" on Android | Locate by resource-id and use `click()` (accessibility click) — coordinate taps can hit the system nav bar. The framework's `click()` already does this. |
| Want to see the report | `gradlew allureServe`. |

Still stuck? Capture the full output with `gradlew test --info --stacktrace` and share it.
