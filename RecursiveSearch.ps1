 # Simple variant
function Search-Text([String]$Path, [String]$IMatch) {
     cd $Path;
     $current_name = $( Get-Item . | Where-Object -Property Attributes -IMatch "Directory").Name;
     if ($current_name -imatch  "visual" -or $current_name -eq "git" -or $current_name -eq "DWN-2858" -or $current_name -eq "Хрень с прошлой работы" ) {
         cd ..;
         return;
     }
         Get-Item -Path "*.sql"    | foreach {
         Select-String -Pattern $IMatch -SimpleMatch -Path $_  |Select-Object -Property Path, Filename, Line;
     }

     $Paths = $(Get-ChildItem . | Where-Object -Property Attributes -IMatch "Directory");
     foreach ($i in $Paths ) {
         Search-Text -Path $i -IMatch $IMatch;
      }
      cd ..;
  };


  # Hard variant
class ResultSearch {
[Object]$File;
[Int]$LineNumber;
[String]$Line;
};

function Search-Text([String]$Path, [String]$IMatch) {
    cd $Path;
    $ResultSet = New-Object System.Collections.ArrayList;
    $current_name = $( Get-Item . | Where-Object -Property Attributes -IMatch "Directory").Name;
    if ($current_name -imatch  "visual" -or $current_name -eq "git" -or $current_name -eq "DWN-2858" -or $current_name -eq "Хрень с прошлой работы" ) {
        cd ..;
        return; 
    }
        Get-Item -Path "*.sql"    | foreach {
        $(Select-String -Pattern $IMatch -SimpleMatch -Path $_  |Select-Object -Property LineNumber, Line -OutVariable $a | Out-Null);
        if ($a -ne $null) {
            [ResultSearch]$temp = New-Object ResultSearch;
            $temp.LineNumber = $a.LineNumber;
            $temp.Line = $a.Line;
            $temp.File = $_;
            $ResultSet.add($temp);

            Remove-Variable a;
            Remove-Variable temp;
        }
    }

    $Paths = $(Get-ChildItem . | Where-Object -Property Attributes -IMatch "Directory");
    foreach ($i in $Paths ) {
        $ResultSet.add($(Search-Text -Path $i -IMatch $IMatch));
     }
     cd ..;
     return $ResultSet;
 };

