plugins { java; id("io.qameta.allure") version "2.12.0" }
group = "com.arabbank"; version = "0.1.0"
java { toolchain { languageVersion.set(JavaLanguageVersion.of(17)) } }
repositories {
    mavenCentral()
    maven { url = uri("https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/") }
}
dependencies { testImplementation("com.qeas.automation:framework-core:0.2.0") }

// Default `gradlew test` runs the API suite (green anywhere). Pick another with -Psuite=<name>,
// e.g. -Psuite=mobile / web / as400 / e2e / regression  (files under src/test/resources/suites/).
val suiteFile = (findProperty("suite") as String?)
    ?.let { "src/test/resources/suites/$it.xml" } ?: "src/test/resources/testng.xml"
tasks.test {
    useTestNG { suites(suiteFile) }
    testLogging { events("passed","skipped","failed"); showStandardStreams = true }
    listOf("target","platform","device","user").forEach { k -> System.getProperty(k)?.let { systemProperty(k, it) } }
    System.getenv("BROWSERSTACK_USER")?.let { environment("BROWSERSTACK_USER", it) }
    System.getenv("BROWSERSTACK_KEY")?.let { environment("BROWSERSTACK_KEY", it) }
}
