<# 
 遍历 mips-asm-test 目录（包含子目录）下的所有 .asm 文件，
 依次复制到 test.asm 并执行：
   python main.py run ..\project\project.xpr test.asm
 一旦出现 error（输出中包含 "error" 或 python 返回码非 0）即停止脚本。
#>

# 固定工作目录为脚本所在目录，保证相对路径正确
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

$AsmRoot    = Join-Path $ScriptDir "mips-asm-test"
$TargetAsm  = Join-Path $ScriptDir "test.asm"
$ProjectXpr = Join-Path $ScriptDir "..\project\project.xpr"

if (-not (Test-Path $AsmRoot)) {
    Write-Error "Asm root directory not found: $AsmRoot"
    exit 1
}

# 递归获取所有 .asm 文件（包含子目录），按路径排序以保证遍历顺序稳定
$AsmFiles = Get-ChildItem -Path $AsmRoot -Filter *.asm -File -Recurse | Sort-Object FullName

if ($AsmFiles.Count -eq 0) {
    Write-Error "No .asm files found under $AsmRoot"
    exit 1
}

$index = 0
foreach ($file in $AsmFiles) {
    $index++
    $relPath = $file.FullName.Substring($AsmRoot.Length).TrimStart('\','/')

    Copy-Item -Path $file.FullName -Destination $TargetAsm -Force
    Write-Host "[$index] Copied $relPath -> test.asm"

    $Args = @("main.py", "run", $ProjectXpr, "test.asm")
    Write-Host "[$index] Running: python $($Args -join ' ')"

    $Output = & python @Args 2>&1
    $ExitCode = $LASTEXITCODE
    $Output | ForEach-Object { Write-Host $_ }

    $HasErrorText = $Output -match '(?i)error'

    if ($ExitCode -ne 0 -or $HasErrorText) {
        $Reason = "error text detected"
        if ($ExitCode -ne 0) { $Reason = "exit code $ExitCode" }

        Write-Error "[$index] main.py failed for ${relPath}: $Reason"

        if ($ExitCode -ne 0) {
            exit $ExitCode
        } else {
            exit 1
        }
    }
    else {
        Write-Host "[$index] Done."
    }
}

Write-Host "All asm files under mips-asm-test processed successfully."


