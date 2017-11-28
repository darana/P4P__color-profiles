$file_type          = "dng"
$log_last           = ".\ingest__log--last.txt"
$log_all            = ".\ingest__log--all.txt"
$log_opcode_files   = ".\ingest__log--opcode-files.txt"
$files_counter      = 0
$total_opcode_files = 0
Out-File $log_last
Out-File $log_opcode_files
get-date | Out-File -append $log_last

$files = Get-ChildItem "." -file -Filter *.$file_type | Select -exp fullname
$total_files = $files.count


  # Write-Host "---------------------------------"
  # Write-Host "Beginning to strip -OpCode3 from total of $total_files P4P DNG files"
  # Write-Host ""

  foreach ($file in $files)
  {
    Write-Progress -Id 1 -Activity "Stripping -OpCodeList3 from $total_files possible DNG files" -Status "-OpCodeList3 Nuked : $files_counter/$total_files" -PercentComplete ($files_counter/$total_files) -CurrentOperation "Current file: $file"
    $camera = exiftool -model $file
    switch -wildcard ($camera)
      {
        "*FC6310" {$camera_code = "P4P"}
        "*FC220"  {$camera_code = "M1P"}
        default   {$camera_code = ""}
      }

      if ($camera_code -eq "P4P")
      {
        $files_counter++
        exiftool.exe -OpcodeList3= -m -overwrite_original -progress -v3 -if "`$EXIF:OpcodeList3 ne ''" $file | tee-object -append -file $log_all | Out-File -append $log_last
        $file | Out-File -append $log_opcode_files
        Write-Host "-OpCodeList3 Removed: $file"
      } else {
        $total_files--
      }
  }

  Write-Host "---------------------------------`n"


  Write-Host "P4P DNG files updated:  $files_counter/$total_opcode_files`n"

  Write-Host "Current Import log:     $log_last"
  Write-Host "All Imorts log:         $log_all"
  Write-Host "Updated P4P DNG files:  $log_opcode_files`n"

  Write-Host "Now, go make some cool shit `n"

  Write-Host "---------------------------------"
  get-date | Out-File -append $log_last
  Pause