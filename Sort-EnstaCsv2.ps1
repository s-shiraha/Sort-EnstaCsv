function Sort-EnstaCsv2 {
    param(
        [parameter(mandatory = $true)][string]$StartingPoint, 
        [ValidateSet("R2L", "L2R")][string]$HDirection = "R2L", 
        [ValidateSet("B2T", "T2B")][string]$VDirection = "B2T", 
        [parameter(mandatory = $true)][int]$StartRow

    )
    $TargetFile = "/home/ym/pwsh/01_Make-CsvRearrange/image_and_csv/niki2.csv"

    $Content = Get-Content -Path $TargetFile -Encoding utf8
    $MaxRow = [int](($Content | Where-Object -FilterScript {$_ -match "^\d+"} | Select-Object -Last 1) -split ",")[0]
    $MaxColumn = (($Content | Where-Object -FilterScript {$_ -match "^1,"}) -split "," | Measure-Object).Count - 1

    "Ingredients`n==========" | Out-Host
    $Content | Where-Object -FilterScript {$_ -match "^\s,"} | ForEach-Object -Process {($_ -split ",") -join "`t"}

    $TargetBlock = Read-Host -Prompt "Select Block"
    $StartingX = [int]($StartingPoint -split ",")[0]
    $StartingZ = [int]($StartingPoint -split ",")[1]

    if($VDirection -eq "B2T"){
        $i_begin = $StartRow
        $i_end = 1
        $i_delta = -1
    } else {
        $i_begin = 1
        $i_end = $StartRow
        $i_delta = 1
    }
    if($HDirection -eq "R2L"){
        $j_begin = $MaxColumn
        $j_end = 1
        $j_delta = -1
    } else {
        $j_begin = 1
        $j_end = $MaxColumn
        $j_delta = 1
    }
    
    for($i = $i_begin; $i -ne ($i_end + $i_delta); $i = $i + $i_delta){
        $TargetCount = 0
        $OutStr = "Z:$($StartingZ + $i - $MaxRow)`n"
        $CurrentLine = ($Content | Select-Object -Skip $i -First 1) -split ","
        for($j = $j_begin; $j -ne ($j_end + $j_delta); $j = $j + $j_delta){
            if($CurrentLine[$j] -eq $TargetBlock){
                if($TargetCount -eq 0){
                    $OutStr += "  from $(($StartingX + $j - $MaxColumn).ToString().PadLeft(4, " ")), count "
                }
                $TargetCount++
            } else {
                if($TargetCount -gt 0){
                    $OutStr += "$($TargetCount.ToString().PadLeft(4, " "))`n"
                    $TargetCount = 0
                }
            }
            <#
            $CurrentLine = ($Content | Select-Object -Skip $i -First 1) -split ","
            $CurrentBlock = $CurrentLine[$j]
            if($CurrentBlock -eq $TargetBlock){
                if($TargetCount -eq 0){
                    $BeginX = $StartingX + $j - $MaxColumn
                    $BeginZ = $StartingZ + $i - $MaxRow
                }
                $TargetCount++
            } else {
                if($TargetCount -gt 0){
                    "${TargetBlock}`t${HDirection}`t(${BeginX},${BeginZ})`tcount=${TargetCount}"
                    $TargetCount = 0
                    Read-Host
                }
            }
            #>
        }
        if($TargetCount -gt 0){
            $OutStr += "$($TargetCount.ToString().PadLeft(4, " "))`n"
        }
        $OutStr | Out-Host
        Read-Host
    }
    
}

#Make-CsvRearrange2 -StartingPoint "-66,-66" -StartRow 93