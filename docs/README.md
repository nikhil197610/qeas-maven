# QEAS Automation Framework — Guidance

Documentation for using the QEAS automation framework (Mobile, Web, API, AS/400 + mixed flows).

| Guide | What it covers |
|-------|----------------|
| [Getting Started](getting-started.md) | Prerequisites, one-command setup, running your first test in VS Code |
| [Project Structure](project-structure.md) | How to organise all four engines + mixed flows |
| [Engines](engines.md) | Mobile / Web / API / AS/400 + mixed, with code patterns |
| [Offline / No-GitHub Install](offline-install.md) | Consume the framework with no GitHub (locked-down networks) |
| [Troubleshooting](troubleshooting.md) | Common errors and fixes |
| [Maintainer Guide](maintainer.md) | Publishing new versions, obfuscation, distribution |

**The framework in one line:** a single dependency (`com.qeas.automation:framework-core`) that brings
Appium, Selenium 4, REST Assured, TestNG, Allure, JTOpen, SikuliX/Tesseract — with page-object bases,
JSON locators, self-healing, retries, and Allure reporting already wired.

**Distribution:** the obfuscated binary is served from a public raw-Maven feed
(`https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/`) — no login, no token. Source is
private. Offline/GitHub-blocked networks use the [local install](offline-install.md).
