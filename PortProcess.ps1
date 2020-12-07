$processler = Get-Process | Select-Object Id, Name;
$portlariAl = netstat -a -n -o;
$1 = $portlariAl[4..$portlariAl.count] | ConvertFrom-String | Select-Object p3,p4,p5,p6 | Where-object{$_.p5 -eq "LISTENING" -or $_.p5 -eq "CLOSE_WAIT" -or $_.p5 -eq "ESTABLISHED" -or $_.p5 -eq "TIME_WAIT"};

$2 = $portlariAl[4..$portlariAl.count] | ConvertFrom-String | Select-Object p3,p4,p5,p6 | Where-object{$_.p5 -ne "LISTENING" -and $_.p5 -ne "CLOSE_WAIT" -and $_.p5 -ne "ESTABLISHED" -and $_.p5 -ne "TIME_WAIT"};


function portlariAl1 {
    Param($p)
    foreach ($i in $p){
        $arr = $i.p3.split(":");
        $count = $arr.count;
        $i.p3 = $arr[$count-1];

        $arr = $i.p4.split(":");
        $count = $arr.count;
        $i.p4 = $arr[$count-1];
     }
}

portlariAl1($1);
portlariAl1($2);


foreach($i in $1){
    $i.p5 = $i.p6;
}

$portlar = $1 + $2;

foreach ($i in $processler){
    foreach ($j in $portlar){
        if ($i.Id -eq $j.p5){
            $j.p6 = $i.Name;
        }
    }
}

$str = "";
foreach($i in $portlar){
    $str += "LocalPort:" + $i.p3 + ", ForeignPort:" + $i.p4 + ", ProcessName:" + $i.p6 + "`n`n";
}
$str > C:\Windows\Temp\PortProcess.txt                                                         