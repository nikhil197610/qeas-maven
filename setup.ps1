<#
  One-shot tester setup for the QEAS automation framework — NO login, NO token.
  The framework binary is served from a public raw-Maven repo; only a JDK 17 is required.

  In the VS Code terminal (PowerShell), run:
    iwr https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/setup.ps1 -OutFile setup.ps1
    powershell -ExecutionPolicy Bypass -File .\setup.ps1 -Name eab-payments
#>
param(
  [string]$Name = "eab-automation",
  [string]$Group = "com.arabbank",
  [string]$Version = "0.2.0"
)
$ErrorActionPreference = "Stop"
$repo    = "https://raw.githubusercontent.com/nikhil197610/qeas-maven/main"
$pkg     = ("$Group.$Name") -replace '-','.'
$pkgPath = $pkg -replace '\.','/'
Write-Host "==> QEAS setup: project='$Name' group='$Group' framework=$Version (no login needed)"

$root = Join-Path (Get-Location) $Name
New-Item -ItemType Directory -Force -Path "$root/src/test/java/$pkgPath/tests" | Out-Null
New-Item -ItemType Directory -Force -Path "$root/src/test/java/$pkgPath/screens" | Out-Null
New-Item -ItemType Directory -Force -Path "$root/src/test/resources/config" | Out-Null

Set-Content "$root/settings.gradle.kts" "rootProject.name = `"$Name`""

Set-Content "$root/build.gradle.kts" @"
plugins {
    java
    id("io.qameta.allure") version "2.12.0"
}
group = "$Group"
version = "0.1.0"
java { toolchain { languageVersion.set(JavaLanguageVersion.of(17)) } }
repositories {
    mavenCentral()
    // Public raw-Maven feed for the framework binary — no credentials.
    maven { url = uri("$repo/") }
}
dependencies {
    // brings Appium/Selenium/REST-Assured/TestNG/Allure transitively from Maven Central
    testImplementation("com.qeas.automation:framework-core:$Version")
}
tasks.test {
    useTestNG { suites("src/test/resources/testng.xml") }
    testLogging { events("passed", "skipped", "failed"); showStandardStreams = true }
}
"@

Set-Content "$root/src/test/resources/testng.xml" @"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
<suite name="$Name" verbose="1">
    <listeners>
        <listener class-name="com.qeas.automation.reporting.RetryListener"/>
        <listener class-name="com.qeas.automation.reporting.AllureListener"/>
    </listeners>
    <test name="smoke">
        <classes><class name="$pkg.tests.SmokeTest"/></classes>
    </test>
</suite>
"@

Set-Content "$root/src/test/java/$pkgPath/tests/SmokeTest.java" @"
package $pkg.tests;

import com.qeas.automation.api.ApiClient;
import org.testng.annotations.Test;
import java.util.Map;

/** Proves the framework is wired in. Replace with your real suites. */
public class SmokeTest {
    @Test
    public void apiEngineIsAvailable() {
        ApiClient api = new ApiClient(Map.of("baseUrl", "https://httpbin.org")).retries(1);
        api.get("/get").assertSuccess().assertField("url", "https://httpbin.org/get");
    }
}
"@

Write-Host "==> project created at $root"

# Install the Gradle wrapper from the public repo (no auth) so only a JDK is needed.
Push-Location $root
try {
    if (-not (Test-Path ".\gradlew.bat")) {
        Write-Host "==> installing the Gradle wrapper (self-bootstraps Gradle)..."
        New-Item -ItemType Directory -Force -Path "gradle/wrapper" | Out-Null
        iwr "$repo/wrapper/gradlew"                                -OutFile "gradlew"
        iwr "$repo/wrapper/gradlew.bat"                            -OutFile "gradlew.bat"
        iwr "$repo/wrapper/gradle/wrapper/gradle-wrapper.jar"      -OutFile "gradle/wrapper/gradle-wrapper.jar"
        iwr "$repo/wrapper/gradle/wrapper/gradle-wrapper.properties" -OutFile "gradle/wrapper/gradle-wrapper.properties"
    }
    Write-Host "==> running smoke test (first run downloads Gradle + deps)..."
    .\gradlew.bat test
} finally { Pop-Location }

Write-Host "==> Done. Project is in .\$Name"
