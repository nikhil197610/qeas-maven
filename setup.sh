#!/usr/bin/env bash
# One-shot tester setup for the QEAS framework — NO login, NO token. Needs only a JDK 17.
#   bash <(curl -fsSL https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/setup.sh) [name] [group] [version]
set -euo pipefail
NAME="${1:-eab-automation}"; GROUP="${2:-com.arabbank}"; VERSION="${3:-0.2.0}"
REPO="https://raw.githubusercontent.com/nikhil197610/qeas-maven/main"
PKG="$(echo "$GROUP.$NAME" | tr '-' '.')"; PKG_PATH="$(echo "$PKG" | tr '.' '/')"
echo "==> QEAS setup: project='$NAME' group='$GROUP' framework=$VERSION (no login needed)"

mkdir -p "$NAME/src/test/java/$PKG_PATH/tests" "$NAME/src/test/resources/config"
cd "$NAME"
echo "rootProject.name = \"$NAME\"" > settings.gradle.kts

cat > build.gradle.kts <<EOF
plugins { java; id("io.qameta.allure") version "2.12.0" }
group = "$GROUP"; version = "0.1.0"
java { toolchain { languageVersion.set(JavaLanguageVersion.of(17)) } }
repositories {
    mavenCentral()
    maven { url = uri("$REPO/") }   // public framework binary, no credentials
}
dependencies { testImplementation("com.qeas.automation:framework-core:$VERSION") }
tasks.test { useTestNG { suites("src/test/resources/testng.xml") }; testLogging { events("passed","skipped","failed") } }
EOF

cat > src/test/resources/testng.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
<suite name="$NAME" verbose="1">
    <listeners>
        <listener class-name="com.qeas.automation.reporting.RetryListener"/>
        <listener class-name="com.qeas.automation.reporting.AllureListener"/>
    </listeners>
    <test name="smoke"><classes><class name="$PKG.tests.SmokeTest"/></classes></test>
</suite>
EOF

cat > "src/test/java/$PKG_PATH/tests/SmokeTest.java" <<EOF
package $PKG.tests;
import com.qeas.automation.api.ApiClient;
import org.testng.annotations.Test;
import java.util.Map;
public class SmokeTest {
    @Test public void apiEngineIsAvailable() {
        new ApiClient(Map.of("baseUrl","https://httpbin.org")).retries(1)
            .get("/get").assertSuccess().assertField("url","https://httpbin.org/get");
    }
}
EOF

# Gradle wrapper from the public repo (no auth) so only a JDK is needed.
mkdir -p gradle/wrapper
curl -fsSL "$REPO/wrapper/gradlew"                                -o gradlew
curl -fsSL "$REPO/wrapper/gradlew.bat"                            -o gradlew.bat
curl -fsSL "$REPO/wrapper/gradle/wrapper/gradle-wrapper.jar"      -o gradle/wrapper/gradle-wrapper.jar
curl -fsSL "$REPO/wrapper/gradle/wrapper/gradle-wrapper.properties" -o gradle/wrapper/gradle-wrapper.properties
chmod +x gradlew
echo "==> running smoke test (first run downloads Gradle + deps)..."
./gradlew test
echo "==> Done. Project is in ./$NAME"
