# Writes catalog2.json: the whole skin list in one file, so the mod loads it in a single request
# instead of fetching every folder's info.json (github rate-limits that burst). Each entry is the
# folder's info.json copied verbatim with a "path" field prepended, so the mod parses it exactly
# like a live info.json fetch. Run from the repo root (generate_catalog.bat calls this for you).
$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$items = @()
foreach ($c in 'Costumes','Accessories','Items','Plinths','Emotes') {
    if (-not (Test-Path $c)) { continue }
    foreach ($d in Get-ChildItem -Directory $c) {
        $info = Join-Path $d.FullName 'info.json'
        if (-not (Test-Path $info)) { continue }
        $body = (Get-Content -LiteralPath $info -Raw).Trim()
        $open = $body.IndexOf('{'); $close = $body.LastIndexOf('}')
        if ($open -lt 0 -or $close -le $open) { continue }
        $inner = $body.Substring($open + 1, $close - $open - 1).Trim().TrimEnd(',').Trim()
        $path = "$c/$($d.Name)"
        $pf = '"path": "' + ($path -replace '\\','\\' -replace '"','\"') + '"'
        if ($inner.Length -eq 0) { $items += "{ $pf }" }
        else { $items += "{ $pf, $inner }" }
    }
}
$joined = ($items | ForEach-Object { "`n$_" }) -join ','
$tail = if ($items.Count -gt 0) { "`n" } else { '' }
$out = "[$joined$tail]"
[System.IO.File]::WriteAllText((Join-Path $root 'catalog2.json'), $out, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Done... catalog2.json written ($($items.Count) skins)"
