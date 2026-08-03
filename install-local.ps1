<#
  Install framework-core into your LOCAL Maven repo (~/.m2/repository) so projects consume it with
  NO GitHub at build time.
    A) network OK:      powershell -ExecutionPolicy Bypass -File .\install-local.ps1
    B) GitHub blocked:  someone hands you framework-core-<v>.jar (+ .pom), then:
       powershell -ExecutionPolicy Bypass -File .\install-local.ps1 -Jar C:\path\framework-core-0.2.0.jar -Pom C:\path\framework-core-0.2.0.pom
  After this, in build.gradle.kts:  repositories { mavenLocal(); mavenCentral() }
#>
param(
  [string]$Version = "0.2.0",
  [string]$Jar = "",
  [string]$Pom = ""
)
$ErrorActionPreference = "Stop"
$feed = "https://raw.githubusercontent.com/nikhil197610/qeas-maven/main/com/qeas/automation/framework-core/$Version"
$dest = Join-Path $HOME ".m2/repository/com/qeas/automation/framework-core/$Version"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
if ($Jar) { Copy-Item $Jar (Join-Path $dest "framework-core-$Version.jar") -Force }
else { Write-Host "downloading jar…"; iwr "$feed/framework-core-$Version.jar" -OutFile (Join-Path $dest "framework-core-$Version.jar") }
if ($Pom) { Copy-Item $Pom (Join-Path $dest "framework-core-$Version.pom") -Force }
else { Write-Host "downloading pom…"; iwr "$feed/framework-core-$Version.pom" -OutFile (Join-Path $dest "framework-core-$Version.pom") }
Write-Host "Installed com.qeas.automation:framework-core:$Version into ~/.m2/repository."
Write-Host "build.gradle.kts:  repositories { mavenLocal(); mavenCentral() }"
