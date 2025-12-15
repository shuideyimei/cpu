Param(
    [int]$Start = 0,   # inclusive start index, e.g. 0 for test_0.asm
    [int]$End   = 0,   # inclusive end index, e.g. 99 for test_99.asm
    [switch]$StopOnFail = $true  # stop the batch on first failure
)

# Always run from the script directory so relative paths stay stable
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

$AsmDir    = Join-Path $ScriptDir "mips-asm-test\random-asms"
$TargetAsm = Join-Path $ScriptDir "test.asm"
$ProjectXpr = Join-Path $ScriptDir "..\project\project.xpr"

if ($Start -gt $End) {
    Write-Error "Start index ($Start) must be <= End index ($End)"
    exit 1
}

for ($i = $Start; $i -le $End; $i++) {
    $AsmName = "test_$i.asm"
    $SourceAsm = Join-Path $AsmDir $AsmName

    if (-not (Test-Path $SourceAsm)) {
        Write-Error "ASM file not found: $SourceAsm"
        if ($StopOnFail) { exit 1 } else { continue }
    }

    Copy-Item -Path $SourceAsm -Destination $TargetAsm -Force
    Write-Host "[$i] Copied $AsmName -> test.asm"

    $Args = @("main.py", "run", $ProjectXpr, "test.asm")
    Write-Host "[$i] Running: python $($Args -join ' ')"

    $Output = & python @Args 2>&1
    $ExitCode = $LASTEXITCODE
    $Output | ForEach-Object { Write-Host $_ }

    $HasErrorText = $Output -match '(?i)error'

    if ($ExitCode -ne 0 -or $HasErrorText) {
        $Reason = "error text detected"
        if ($ExitCode -ne 0) { $Reason = "exit code $ExitCode" }

        Write-Error "[$i] main.py failed: $Reason"
        if ($StopOnFail) {
            if ($ExitCode -ne 0) {
                exit $ExitCode
            } else {
                exit 1
            }
        }
    }
    else {
        Write-Host "[$i] Done."
    }
}

Write-Host "All requested asm files processed."

