# eab-payments — QEAS framework example project

A ready-to-run project showing all four engines + a mixed (cross-engine) flow.

- `gradlew test`                 → runs the API suite (green anywhere, no device/host)
- `gradlew test -Psuite=mobile`  → mobile suite (needs an Appium device/BrowserStack; see config/)
- `gradlew test -Psuite=web`     → web suite (Selenium)
- `gradlew test -Psuite=as400`   → AS/400 backend checks
- `gradlew test -Psuite=e2e`     → mixed mobile→API→AS/400 flow
- `gradlew test -Psuite=regression` → everything

See the folder layout in the repo root README.
