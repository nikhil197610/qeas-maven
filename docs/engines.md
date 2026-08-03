# Engines

The framework has four engines behind one dependency. All examples below are in
[`examples/eab-payments`](../examples/eab-payments) and compile against the published jar.

## Mobile (Appium)
Page objects extend `BaseScreen`; tests extend `BaseMobileTest` (the framework builds the Appium
driver from `config/` + `-Dtarget`). Locators live in JSON.

```java
// screen (page object)
public class LoginScreen extends BaseScreen {
    public LoginScreen(AppiumDriver driver, LocatorContext locatorContext) {
        super(driver, "common/LoginScreen", locatorContext);   // -> locators/common/LoginScreen.json
    }
    public void loginAs(String user, String pass) {
        clearAndType(locate("username"), user);
        clearAndType(locate("password"), pass);
        hideKeyboard();
        click(locate("loginButton"));
    }
}

// test
public class LoginMobileTest extends BaseTest {           // BaseTest extends BaseMobileTest
    @Test public void userCanLogIn() {
        LoginData creds = LoginData.from(user("internal"));
        HomeScreen home = new LoginFlow(driver(), locatorContext).login(creds.username(), creds.password());
        assertTrue(home.isLoaded());
    }
}
```
Run: `gradlew test -Psuite=mobile` (set the device/app in `config/android.yaml` / `browserstack.yaml`,
plus `BROWSERSTACK_USER` / `BROWSERSTACK_KEY` for cloud).

## Web (Selenium 4)
Pages extend `BasePage`. A web test builds its own `WebDriver` via `DriverFactory`.
```java
public class LoginPage extends BasePage {
    public LoginPage(WebDriver driver) { super(driver); }
    public void loginAs(String u, String p) {
        clearAndType(driver.findElement(By.id("username")), u);
        clearAndType(driver.findElement(By.id("password")), p);
        click(driver.findElement(By.id("login")));
    }
}
// test: WebDriver d = DriverFactory.create(Platform.WEB, ConfigLoader.load(Platform.WEB));
```
Run: `gradlew test -Psuite=web` (browser in `config/web.yaml`).

## API (REST Assured)
`ApiClient` with fluent auth/retry/JSON-schema and Allure attachments; `ApiResponse` for assertions.
```java
new ApiClient(Map.of("baseUrl", "https://api.internal"))
    .auth(ApiAuth.bearer(token)).retries(2)
    .get("/accounts/123")
    .assertSuccess()
    .assertField("currency", "GBP");
```
Run: `gradlew test` (default) or `-Psuite=api`. Needs no device/host — great for CI smoke.

## AS/400 (EQUATION backend) — headless
- **`AS400System`** — run CL commands / call programs (JTOpen), `try`-with-resources.
- **`AS400Client`** — JDBC queries against EQUATION tables.
- **`HaclTerminal`** (`Terminal5250Client`) — headless 5250 green-screen (IBM HACL). It needs IBM
  ACS's `acshod2.jar`, so it is **not** in the public jar; enable it on an ACS-equipped runner.
```java
try (AS400System ibmi = new AS400System(host, user, password)) {
    List<String> out = ibmi.runCommand("DSPLIBL");
}
```
Run: `gradlew test -Psuite=as400` (host/creds in `config/as400.yaml`).

## Mixed (cross-engine end-to-end)
One scenario spanning engines: act on **mobile**, then verify on the **API** and the **AS/400** backend.
```java
public class TransferThenVerifyE2ETest extends BaseTest {   // mobile part
    @Test public void transferThenVerify() {
        HomeScreen home = new LoginFlow(driver(), locatorContext).login(user, pass);
        String ref = /* drive the transfer, capture EW- reference */ "EW-123456";

        new ApiClient(Map.of("baseUrl","https://api.internal")).get("/transfers/"+ref).assertSuccess();

        try (AS400System ibmi = new AS400System(host, user, password)) {
            List<String> txns = ibmi.runCommand("DSPLIBL");   // assert the posting landed
        }
    }
}
```
Run: `gradlew test -Psuite=e2e`. Put anything that spans engines in `e2e/`; keep engine-specific page
objects in their own engine folder.
