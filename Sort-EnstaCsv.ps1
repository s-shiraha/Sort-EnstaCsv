$TargetFile = "/home/ym/pwsh/01_Make-CsvRearrange/image_and_csv/niki2.csv"

$Content = Get-Content -Path $TargetFile -Encoding utf8
$MaxRow = [int](($Content | Where-Object -FilterScript {$_ -match "^\d+"} | Select-Object -Last 1) -split ",")[0]
$LineNum = Read-Host -Prompt "Line?>>"
$TargetLine = ($Content | Where-Object -FilterScript {$_ -match "^${LineNum},"}) -split ","

$GroupList = New-Object -TypeName System.Collections.Arraylist
$ToAdd = [PSCustomObject]@{
    "BlockName" = ""
    "Cnt" = 0
    "TotalCnt" = 0
}
$TargetLine[1..($TargetLine.Count - 1)].Foreach({
    $Line = $_
    if($Line -eq $ToAdd.BlockName){
        $ToAdd.Cnt += 1
        $ToAdd.TotalCnt += 1
    } else {
        if($ToAdd.BlockName -ne ""){$GroupList.Add($ToAdd) | Out-Null}
        $ToAdd = [PSCustomObject]@{
            "BlockName" = $Line
            "Cnt" = 1
            "TotalCnt" = $ToAdd.TotalCnt + 1
        }
    }
    if($ToAdd.TotalCnt -ge $MaxRow){
        $GroupList.Add($ToAdd) | Out-Null
    }
})

$TargetLine[1..($TargetLine.Count - 1)] | `
    Group-Object | `
        Select-Object -Property Name, Count | `
            Sort-Object -Property Count -Descending | `
            Format-Table -AutoSize

$GroupList.ForEach({
    $_ | Out-Host
    Read-Host
})
