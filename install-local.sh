#!/usr/bin/env bash
# Install framework-core into your LOCAL Maven repo (~/.m2/repository) so projects consume it with
# NO GitHub at build time. Two ways:
#   A) network OK:   bash install-local.sh                 # downloads the jar+pom once from the feed
#   B) GitHub blocked: someone hands you framework-core-<v>.jar (+ .pom); then:
#                      bash install-local.sh /path/framework-core-0.2.0.jar /path/framework-core-0.2.0.pom
# After this, in build.gradle.kts use:  repositories { mavenLocal(); mavenCentral() }
# (transitive deps — Appium/Selenium/… — still come from Maven Central / your internal mirror.)
set -euo pipefail
VER="${VERSION:-0.2.0}"
JAR="${1:-}"; POM="${2:-}"
FEED="https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/com/qeas/automation/framework-core/$VER"
DEST="$HOME/.m2/repository/com/qeas/automation/framework-core/$VER"
mkdir -p "$DEST"
if [ -n "$JAR" ]; then cp "$JAR" "$DEST/framework-core-$VER.jar";
else echo "downloading jar…"; curl -fsSL "$FEED/framework-core-$VER.jar" -o "$DEST/framework-core-$VER.jar"; fi
if [ -n "$POM" ]; then cp "$POM" "$DEST/framework-core-$VER.pom";
else echo "downloading pom…"; curl -fsSL "$FEED/framework-core-$VER.pom" -o "$DEST/framework-core-$VER.pom"; fi
echo "Installed com.qeas.automation:framework-core:$VER into ~/.m2/repository."
echo "build.gradle.kts:  repositories { mavenLocal(); mavenCentral() }"
