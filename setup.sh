#!/usr/bin/env bash
# One-shot tester setup for the QEAS framework — NO login, NO token. Needs only a JDK 17.
#   bash <(curl -fsSL https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/setup.sh) [project-name]
set -euo pipefail
NAME="${1:-eab-payments}"
REPO="https://raw.githubusercontent.com/nikhil197610/qeas-maven/main"
TPL="$REPO/examples/eab-payments"
echo "==> QEAS setup: creating '$NAME' with Mobile/Web/API/AS400 + mixed examples (no login needed)"

# Copy the example project (all four engines + a mixed flow) via its manifest.
mkdir -p "$NAME"
for rel in $(curl -fsSL "$TPL/.manifest"); do
  mkdir -p "$NAME/$(dirname "$rel")"
  curl -fsSL "$TPL/$rel" -o "$NAME/$rel"
done
echo "rootProject.name = \"$NAME\"" > "$NAME/settings.gradle.kts"

# Gradle wrapper from the public repo (no auth) so only a JDK is needed.
cd "$NAME"
mkdir -p gradle/wrapper
curl -fsSL "$REPO/wrapper/gradlew"                                 -o gradlew
curl -fsSL "$REPO/wrapper/gradlew.bat"                             -o gradlew.bat
curl -fsSL "$REPO/wrapper/gradle/wrapper/gradle-wrapper.jar"       -o gradle/wrapper/gradle-wrapper.jar
curl -fsSL "$REPO/wrapper/gradle/wrapper/gradle-wrapper.properties" -o gradle/wrapper/gradle-wrapper.properties
chmod +x gradlew

echo "==> running the API suite (first run downloads Gradle + deps)..."
./gradlew test
echo "==> Done. Project in ./$NAME"
echo "    Try: ./gradlew test -Psuite=mobile | web | as400 | e2e | regression"
