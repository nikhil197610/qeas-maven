# Project Structure

Organise **by engine**, with a top-level `e2e/` for scenarios that cross engines. This is the same
shape as the real EAB project: page objects → flows → data records → data-driven tests.

```
src/test/
  java/com/arabbank/eab/payments/
    support/  BaseTest.java                        # extends BaseMobileTest, loads config/testdata.yaml
    mobile/                                         # Appium
       screens/common/  LoginScreen.java HomeScreen.java   # page objects (extend BaseScreen)
       flows/           LoginFlow.java                      # reusable multi-screen flows
       data/            LoginData.java                       # data records from testdata.yaml
       tests/           LoginMobileTest.java                 # data-driven test
    web/                                            # Selenium 4
       pages/  LoginPage.java                        # extend BasePage
       tests/  LoginWebTest.java
    api/      tests/AccountApiTest.java             # REST Assured — ApiClient
    as400/    tests/BackendChecksAs400Test.java     # JTOpen AS400System / AS400Client
    e2e/      tests/TransferThenVerifyE2ETest.java  # MIXED: mobile → verify via API + AS/400
  resources/
    config/    android.yaml ios.yaml browserstack.yaml web.yaml api.yaml as400.yaml testdata.yaml
    locators/  common/LoginScreen.json              # JSON locators, grouped by feature module
    suites/    mobile.xml web.xml api.xml as400.xml e2e.xml regression.xml
    testng.xml                                      # default suite = API (green anywhere)
```

## The layers
- **Screens / Pages** (page objects) — one class per screen. Extend `BaseScreen` (mobile) or
  `BasePage` (web). They locate + act; they hold no test logic. Group by feature module
  (`screens/common`, `screens/payments`, …), matching the locator folders.
- **Flows** — reusable sequences that compose screens (e.g. `LoginFlow.login()`). Every test that
  needs a logged-in session calls the flow, so a step exists in exactly one place.
- **Data** — records built from `testdata.yaml` (`LoginData.from(map)`), so tests are data-driven and
  the same flow runs for different data/users.
- **Tests** — thin: get data → drive a flow → assert. Mobile/e2e tests extend the project `BaseTest`.
- **Locators** — never in code. JSON per screen under `resources/locators/<module>/<Screen>.json`,
  with android/ios strategy lists (self-healing tries them in order).
- **Config** — per engine under `resources/config/`. Secrets via `${ENV:-default}`, never hardcoded.
- **Suites** — one TestNG XML per engine under `resources/suites/`; select with `-Psuite=<name>`.

## Growing the project
- **New screen** → add the page object + its locator JSON.
- **New scenario** → add a flow (compose screens) + a data record + a test.
- **New engine test** → drop it in that engine's `tests/` and list it in the engine's suite XML.
- **Cross-engine check** → put it in `e2e/`: extend `BaseTest` for the mobile part, then call
  `ApiClient` / `AS400System` in the same test to verify the backend.

## Choosing the run scope
```
gradlew test                    # default: API only (safe, no infra)
gradlew test -Psuite=mobile     # needs an Appium device / BrowserStack
gradlew test -Psuite=web        # needs a browser
gradlew test -Psuite=as400      # needs an AS/400 host
gradlew test -Psuite=e2e        # mixed; needs mobile + backend
gradlew test -Psuite=regression # everything
```
