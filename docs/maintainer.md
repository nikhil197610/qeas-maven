# Maintainer Guide

How the framework is built, protected, and published. **Consumers don't need this.**

## Repos
- **Framework source** (private) — the code; only maintainers have access.
- **`nikhil197610/qeas-maven`** (public) — this repo: serves the **obfuscated binary** as a raw-Maven
  feed + the scaffolder/examples. No source here.
- **`ACABES-AUTOMATION/qeas-framework-dist`** (private) — the same binary via GitHub Packages, for a
  more locked-down (non-public) distribution if ever needed.

## Cut a new version (e.g. 0.3.0)
Build the **obfuscated** jar from the framework repo:
```bash
./gradlew -PframeworkVersion=0.3.0 -Pdist :framework-core:protectJar \
          :framework-core:generatePomFileForMavenPublication
```
- `-Pdist` strips debug info (`-g:none`); `protectJar` runs ProGuard (`dist/proguard-rules.pro`):
  keeps the public API, renames internals, strips source/line info.
- Output: `framework-core/build/libs/framework-core-0.3.0-protected.jar`.

Publish to the **public feed** (Maven layout at the repo root):
```bash
DEST=com/qeas/automation/framework-core/0.3.0
mkdir -p $DEST
cp framework-core/build/libs/framework-core-0.3.0-protected.jar $DEST/framework-core-0.3.0.jar
cp framework-core/build/publications/maven/pom-default.xml       $DEST/framework-core-0.3.0.pom
# (optional) checksums:
for f in $DEST/framework-core-0.3.0.jar $DEST/framework-core-0.3.0.pom; do shasum -a1 "$f" | awk '{print $1}' > "$f.sha1"; done
git add $DEST && git commit -m "publish 0.3.0" && git push
```
Then bump the version in `setup.ps1`/`setup.sh` defaults, `examples/eab-payments/build.gradle.kts`,
and the READMEs, and tell consumers.

> Versions are **immutable** — never overwrite a published version; always bump the number.

## Private GitHub Packages (optional, more locked down)
Committing a jar+pom under `artifacts/` in `ACABES-AUTOMATION/qeas-framework-dist` and pushing runs its
`deploy.yml` workflow, which publishes to that repo's GitHub Packages using the built-in token
(no PAT). Consumers there need a `read:packages` token + read on the repo. See that repo's README.

## Verifying a build
The obfuscated jar is verified by scaffolding `examples/eab-payments` against it and running the API
suite (`gradlew test`) + compiling every engine. Do this after each `protectJar` change — reflection
targets (TestNG listeners, Jackson) can break under obfuscation and need a matching `-keep` rule.
