$file_type         = "dng"
$log_last          = ".\ingest__log--last.txt"
$log_all           = ".\ingest__log--all.txt"
$log_opcode_files  = ".\ingest__log--opcode-files.txt"
Out-File $log_last
Out-File $log_opcode_files

$files = Get-ChildItem "." -file -Filter *.$file_type | Select -exp fullname
$total_files = $files.count

	Write-Host "---------------------------------"
  Write-Host "Beginning to strip -OpCode3 from total of $total_files P4P DNG files"
  Write-Host ""

	foreach ($file in $files) {
	  $files_counter++

		exiftool.exe -OpcodeList3= -m -overwrite_original -progress -v3 $file | tee-object -append -file $log_all | Out-File -append $log_last
    $file | Out-File -append $log_opcode_files
    Write-Host "-Opcode3 Remove: $files_counter/$total_files Filename: $file"
  }

  Write-Host ""
  Write-Host ""
  Write-Host "See exiftoollog--last.txt for detailed logs of this last run"
  Write-Host "See exiftoollog--all.txt for detailed logs of all runs in this directory"
  Write-Host ""
  Write-Host "Now, go make some cool shit"