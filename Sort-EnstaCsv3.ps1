function Sort-EnstaCsv3 {
    param(
        [parameter(Mandatory)][int]$StartX, 
        [parameter(Mandatory)][int]$StartZ, 
        [int]$StartColumn = 128
    )

    $TargetFile = "${HOME}\pwsh\image_and_csv\nazuna3_MC.csv"
    "TargetFile:${TargetFile}" | Out-Host

    $TargetWidth = 128
    $StartY = 191

    $CsvContent = Get-Content -Path $TargetFile -Encoding UTF8 | `
                    Select-Object -First ($TargetWidth + 1) | `
                        ConvertFrom-Csv -Delimiter ","

    #Columnを降順で走査
    for($j = $TargetWidth; $j -gt 0; $j--){
        #ブロックを置き始めるy座標を計算
        $MaxHeight = 0
        $MinHeight = 0
        $Height = 0
        for($i = $TargetWidth; $i -gt 0; $i--){
            #(明)なら$i - 1のブロックのy座標が-1
            if($CsvContent."${j}"[$i] -match "\(明\)$"){
                $Height--
                if($MinHeight -gt $Height){$MinHeight = $Height}
            }
            #(暗)なら$i - 1のブロックのy座標が+1
            if($CsvContent."${j}"[$i] -match "\(暗\)"){
                $Height++
                if($MaxHeight -lt $Height){$MaxHeight = $Height}
            }
            #(標準)なら$i - 1のブロックのy座標が+0、何もしない
        }
        "X:$($j - $TargetWidth + $StartX)`tStartY:$($StartY - $MinHeight)" | Out-Host
        
        for($i = $TargetWidth - 1; $i -ge 0; $i--){
            #置くブロック名を表示
            $Y_Delta = "Y_Delta = +0"
            if($i -ne $TargetWidth - 1){
                if($CsvContent."${j}"[$i + 1] -match "\(明\)$"){
                    $Y_Delta = "Y_Delta = -1"
                } elseif($CsvContent."${j}"[$i + 1] -match "\(暗\)$"){
                    $Y_Delta = "Y_Delta = +1"
                }
            }
            "$($CsvContent."${j}"[$i])`tX:$($StartX + $j - $TargetWidth)`tZ:$($StartZ + $i - $TargetWidth)`t${Y_Delta}" | Out-Host
            Read-Host
        }
    }
}

Sort-EnstaCsv3 -StartX -193 -StartZ -65 -StartColumn 128