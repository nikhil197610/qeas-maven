<#
  One-shot tester setup for the QEAS automation framework — NO login, NO token.
  Creates a project with Mobile / Web / API / AS400 + a mixed (cross-engine) example. Needs a JDK 17.

  In the VS Code terminal (PowerShell):
    iwr https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/setup.ps1 -OutFile setup.ps1
    powershell -ExecutionPolicy Bypass -File .\setup.ps1 -Name eab-payments
#>
param(
  [string]$Name = "eab-payments"
)
$ErrorActionPreference = "Stop"
$repo = "https://raw.githubusercontent.com/nikhil197610/qeas-maven/main"
$tpl  = "$repo/examples/eab-payments"
Write-Host "==> QEAS setup: creating '$Name' with Mobile/Web/API/AS400 + mixed examples (no login needed)"

# Copy the example project (all four engines + a mixed flow) via its manifest.
New-Item -ItemType Directory -Force -Path $Name | Out-Null
$manifest = (iwr "$tpl/.manifest").Content -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
foreach ($rel in $manifest) {
    $dest = Join-Path $Name $rel
    New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
    iwr "$tpl/$rel" -OutFile $dest
}
Set-Content (Join-Path $Name "settings.gradle.kts") "rootProject.name = `"$Name`""

# Gradle wrapper from the public repo (no auth) so only a JDK is needed.
Push-Location $Name
try {
    New-Item -ItemType Directory -Force -Path "gradle/wrapper" | Out-Null
    iwr "$repo/wrapper/gradlew"                                  -OutFile "gradlew"
    iwr "$repo/wrapper/gradlew.bat"                              -OutFile "gradlew.bat"
    iwr "$repo/wrapper/gradle/wrapper/gradle-wrapper.jar"        -OutFile "gradle/wrapper/gradle-wrapper.jar"
    iwr "$repo/wrapper/gradle/wrapper/gradle-wrapper.properties" -OutFile "gradle/wrapper/gradle-wrapper.properties"
    Write-Host "==> running the API suite (first run downloads Gradle + deps)..."
    .\gradlew.bat test
} finally { Pop-Location }

Write-Host "==> Done. Project in .\$Name"
Write-Host "    Try: .\gradlew.bat test -Psuite=mobile | web | as400 | e2e | regression"
