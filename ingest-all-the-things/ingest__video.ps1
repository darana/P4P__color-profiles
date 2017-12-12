# Set Variables - For easy changing later
  # USER VARIABLES
    # $memory_card          = "D:\#Data\!Pictures\!Photographs\Aerial\testing_card" # For testing
    $memory_card          = "k:\dcim"
    $file_types           = @("mp4", "mov", "insv")

  # Housekeeping Variables
    # $opcode_files         = New-Object System.Collections.Generic.List[System.Object]
    $total_files          = 0
    $total_files_of_type  = 0
    $total_opcode_files   = 0
    $files_counter        = 0
    $opcode_files_counter = 0
    $opcode_files_regex   = '(?<=--> '').*(?=\'')'
    $log_last             = ".\ingest__log--last.txt"
    $log_all              = ".\ingest__log--all.txt"
    $log_opcode_files     = ".\ingest__log--opcode-files.txt"
    Out-File $log_last
    Out-File $log_opcode_files
    Write-Output "Import started " | Out-File -append $log_last
    get-date | Out-File -append $log_last

  # Get count of total_files of the types we're looking for so we can display progress
  foreach ($file_type in $file_types) {
    $total_files_of_type = Get-ChildItem "$memory_card" -recurse -file -Filter *.$file_type
    $total_files = $total_files + $total_files_of_type.count
  }

# Write-Host "`nCopying files from $memory_card`n"

# Loop through all of the file_types on the card. Grabs all of the files of each file_type
# For reach file we're checking the camera model and serial numbers to assign codes for renaming
# Also want the model so we can strip  -opcodes3 from Phantom 4 Pro DNG files to clear lens profile
  foreach ($file_type in $file_types) {
    $files = Get-ChildItem "$memory_card" -recurse -file -Filter *.$file_type | Select -exp fullname
    foreach ($file in $files) {
      $files_counter++
      Write-Progress -Id 1 -Activity "Ingesting $memory_card" -Status "Copying: $files_counter/$total_files" -PercentComplete ($files_counter/$total_files) -CurrentOperation "Current file: $file"

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
          "*944c5c7ca3aa24ee43b43f2c7e129a7*" {$camera_actual = " - P4P-01"}
          "*c44879200a2f1322b12d25c3b858163*" {$camera_actual = " - P4P-02"}
          "*2014031100*"                      {$camera_actual = " - MV1-03"}
          $null                               {$camera_actual = $camera_code}
          default                             {$camera_actual = $camera_code}
        }

      $camera_code_folder       = "__[$camera_code]--"
      $camera_code_file         = "__[$camera_code]--"

      # if ($file_type -eq "dng" -AND $camera_code -eq "P4P") {
      #   # If a DNG file from a Phantom 4 Pro camera, saving the file into an array so we can strip off the opcodes
      #   # Doing this instead of stripping at the time of copy b/c it slows down the copy & so multiple cards is slower
      #   # $opcode_files.add($file)
      #   $total_opcode_files++
      # }

      exiftool -r -m -o . -v3 -d "Media\%Y-%m-%d$camera_code_folder\%Y%m%d-%H%M$camera_code_file%%f.%%e" "-filename<createdate" $file | tee-object -append -file $log_all | Out-File -append $log_last


    }
  }
  Write-Host "---------------------------------`n"

  Write-Host "All Files Copied, Renamed, and Sorted`n"

  Write-Host "!!! You can safely remove the memory card !!!`n"

  Write-Host "---------------------------------`n"

  Write-Host "Files Copied:           $files_counter/$total_files"
  Write-Host "Current Import log:     $log_last"
  Write-Host "All Imorts log:         $log_all"
  Write-Host "Now, go make some cool shit `n"

  Write-Host "---------------------------------"
  get-date | Out-File -append $log_last
  Pause