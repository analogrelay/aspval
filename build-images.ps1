param(
    [Parameter(Mandatory=$false)][string]$Subtag = $null
)

if($Subtag -and !$Subtag.StartsWith("-")) {
    $Subtag = "-$Subtag"
}

function exec($cmd) {
    Write-Host -ForegroundColor Magenta "> $cmd $args"
    & "$cmd" @args
    if($LASTEXITCODE -ne 0) {
        Write-Host -ForegroundColor Red $result
        throw "Command failed!"
    }
}

$subtagBuildArg = @()
if($Subtag) {
    $subtagBuildArg = @("--build-arg", "SUBTAG=$Subtag")
}

$AppsDir = Join-Path $PSScriptRoot "Apps"
Get-ChildItem -Directory $AppsDir | ForEach-Object {
    $fx = $_.Name
    Write-Host -ForegroundColor Green "Building Docker Images for ASP.NET Core $fx"
    Get-ChildItem -Directory $_.FullName | ForEach-Object {
        $scenario = $_.Name
        Write-Host -ForegroundColor Green " Building scenario $scenario"
        Get-ChildItem $_.FullName -Filter *.Dockerfile | ForEach-Object {
            $deployment = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
            Write-Host -ForegroundColor Green "  Building deployment mode $deployment"
            $tag = "aspval/$fx/$scenario/$deployment".ToLowerInvariant()
            $baseDir = Split-Path -Parent $_.FullName
            exec docker build --tag $tag --file $_.FullName @subtagBuildArg --label aspval=1 --label aspval-fx=$fx --label aspval-scenario=$scenario --label aspval-deployment=$deployment $baseDir
        }
    }
}