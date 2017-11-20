$file_type           = "dng"

$files = Get-ChildItem "." -file -Filter *.$file_type | Select -exp fullname
$total_files = $files.count

	Write-Host "---------------------------------"
  Write-Host "Beginning to strip -OpCode3 from total of $total_files P4P DNG files"
  Write-Host ""

	foreach ($file in $files) {
	  $files_counter++

		exiftool.exe -OpcodeList3= -m -overwrite_original -progress -v3 $file | tee-object -append -file .\exiftoollog--all.txt | Out-File -append .\exiftoollog-_last.txt
    Write-Host "-Opcode3 Remove: $files_counter/$total_files Filename: $file"
  }

  Write-Host ""
  Write-Host ""
  Write-Host "See exiftoollog--last.txt for detailed logs of this last run"
  Write-Host "See exiftoollog--all.txt for detailed logs of all runs in this directory"
  Write-Host ""
  Write-Host "Now, go make some cool shit"