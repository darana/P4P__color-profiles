# Set Variables - For easy changing later
  # USER VARIABLES
    # $memory_card          = "D:\#Data\!Pictures\!Photographs\Aerial\testing_card"
    $memory_card        = "k:\dcim"
    $file_types           = @("dng", "jpg", "jpeg")    

  # Housekeeping Variables
    $opcode_files         = New-Object System.Collections.Generic.List[System.Object]
    $total_files          = 0
    $total_files_of_type  = 0
    $total_opcode_files   = 0
    $files_counter        = 0
    $opcode_files_counter = 0
    
  # Get count of total_files of the types we're looking for so we can display progress
  foreach ($file_type in $file_types) {
    $total_files_of_type = Get-ChildItem "$memory_card" -recurse -file -Filter *.$file_type
    $total_files = $total_files + $total_files_of_type.count
  }    

# Loop through all of the file_types on the card. Grabs all of the files of each file_type
# For reach file we're checking the camera model and serial numbers to assign codes for renaming
# Also want the model so we can strip  -opcodes3 from Phantom 4 Pro DNG files to clear lens profile
  foreach ($file_type in $file_types) {
    $files = Get-ChildItem "$memory_card" -recurse -file -Filter *.$file_type | Select -exp fullname
    foreach ($file in $files) {
      # Progress counter
      $files_counter++

      $camera = exiftool -model $file
      switch -wildcard ($camera)
      {
        "*FC6310" {$camera_code = "P4P"}
        "*FC220"  {$camera_code = "M1P"}
        default   {$camera_code = ""}
      }
      
      $serial = exiftool -SerialNumber $file
      switch -wildcard ($serial)
        # To add/remove/change individual cameras, change the serial number on the left and corresponding name on the right
        # Be sure to keep the * as a wildcard at start and end so it matches the exiftool output.
        {
          "*944c5c7ca3aa24ee43b43f2c7e129a7*" {$camera_actual = "P4P-02"}
          "*2014031100*"                      {$camera_actual = "MV1-03"}
          $null                               {$camera_actual = $camera_code}
          default                             {$camera_actual = $camera_code}
        }
      
      if ($file_type -eq "dng" -AND $camera_code -eq "P4P") {
        # If a DNG file from a Phantom 4 Pro camera, saving the file into an array so we can strip off the opcodes
        # Doing this instead of stripping at the time of copy b/c it slows down the copy & so multiple cards is slower
        $opcode_files.add($file)
        $total_opcode_files++
      }
      exiftool -r -m -o . -v3 -d "%Y\%Y-%m-%d - [$camera_actual]\%Y%m%d-$camera_code--%%f.%%e" "-filename<createdate" $file | tee-object -append -file .\exiftoollog--all.txt | Out-File .\exiftoollog-_last.txt

      Write-Host "---------------------------------"
      Write-Host "Copied:             $files_counter/$total_files"
      Write-Host "Profile Nuke Queue: $total_opcode_files"
    }    
  }
  Write-Host "---------------------------------"
  Write-Host ""
  Write-Host "All Files Copied, Renamed, and Sorted"
  Write-Host ""
  Write-Host "!!! You can safely remove the memory card !!!"
  Write-Host ""
  Write-Host "---------------------------------"
  Write-Host "Beginning to strip -OpCode3 from total of $total_opcode_files P4P DNG files"
  Write-Host ""
  $opcode_files.ToArray() | tee-object -append -file .\exiftoollog--all.txt | Out-File -append .\exiftoollog-_last.txt
  foreach ($opcode_file in $opcode_files) {
    $opcode_files_counter++
    exiftool.exe -OpcodeList3= -m -overwrite_original -progress -v3 $opcode_file | tee-object -append -file .\exiftoollog--all.txt | Out-File -append .\exiftoollog-_last.txt      
      Write-Host "-Opcode3 Removed:   $opcode_files_counter/$total_opcode_files" 
  }
  Write-Host "---------------------------------"
  Write-Host ""
  Write-Host ""
  Write-Host "$files_counter of $total_files copied"
  Write-Host "$opcode_files_counter of $total_opcode_files P4P DNG Profiles stripped"
  Write-Host "See exiftoollog--last.txt for detailed logs of current import"
  Write-Host "See exiftoollog--all.txt for detailed logs of import history"
  Write-Host ""
  Write-Host "Now, go make some cool shit"
  Write-Host ""
  Write-Host ""
  Write-Host "---------------------------------"
  Pause