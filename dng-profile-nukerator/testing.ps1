Set-StrictMode -Version Latest
Function Get-IniContent {
    <#
    .Synopsis
        Gets the content of an INI file

    .Description
        Gets the content of an INI file and returns it as a hashtable

    .Notes
        Author    : Oliver Lipkau <oliver@lipkau.net>
    Source    : https://github.com/lipkau/PsIni
                      http://gallery.technet.microsoft.com/scriptcenter/ea40c1ef-c856-434b-b8fb-ebd7a76e8d91
        Version   : 1.0.0 - 2010/03/12 - OL - Initial release
                      1.0.1 - 2014/12/11 - OL - Typo (Thx SLDR)
                                              Typo (Thx Dave Stiff)
                      1.0.2 - 2015/06/06 - OL - Improvment to switch (Thx Tallandtree)
                      1.0.3 - 2015/06/18 - OL - Migrate to semantic versioning (GitHub issue#4)
                      1.0.4 - 2015/06/18 - OL - Remove check for .ini extension (GitHub Issue#6)
                      1.1.0 - 2015/07/14 - CB - Improve round-tripping and be a bit more liberal (GitHub Pull #7)
                                           OL - Small Improvments and cleanup
                      1.1.1 - 2015/07/14 - CB - changed .outputs section to be OrderedDictionary
                      1.1.2 - 2016/08/18 - SS - Add some more verbose outputs as the ini is parsed,
                                          allow non-existent paths for new ini handling,
                                          test for variable existence using local scope,
                                          added additional debug output.

        #Requires -Version 2.0

    .Inputs
        System.String

    .Outputs
        System.Collections.Specialized.OrderedDictionary

    .Parameter FilePath
        Specifies the path to the input file.

    .Parameter CommentChar
        Specify what characters should be describe a comment.
        Lines starting with the characters provided will be rendered as comments.
        Default: ";"

    .Parameter IgnoreComments
        Remove lines determined to be comments from the resulting dictionary.

    .Example
        $FileContent = Get-IniContent "C:\myinifile.ini"
        -----------
        Description
        Saves the content of the c:\myinifile.ini in a hashtable called $FileContent

    .Example
        $inifilepath | $FileContent = Get-IniContent
        -----------
        Description
        Gets the content of the ini file passed through the pipe into a hashtable called $FileContent

    .Example
        C:\PS>$FileContent = Get-IniContent "c:\settings.ini"
        C:\PS>$FileContent["Section"]["Key"]
        -----------
        Description
        Returns the key "Key" of the section "Section" from the C:\settings.ini file

    .Link
        Out-IniFile
    #>

    [CmdletBinding()]
    [OutputType(
        [System.Collections.Specialized.OrderedDictionary]
    )]
    Param(
        [ValidateNotNullOrEmpty()]
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)]
        [string]$FilePath,
        [char[]]$CommentChar = @(";"),
        [switch]$IgnoreComments
    )

    Begin
    {
        Write-Debug "PsBoundParameters:"
        $PSBoundParameters.GetEnumerator() | ForEach-Object { Write-Debug $_ }
        if ($PSBoundParameters['Debug']) { $DebugPreference = 'Continue' }
        Write-Debug "DebugPreference: $DebugPreference"

        Write-Verbose "$($MyInvocation.MyCommand.Name):: Function started"

        $commentRegex = "^([$($CommentChar -join '')].*)$"
        Write-Debug ("commentRegex is {0}." -f $commentRegex)
    }

    Process
    {
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Processing file: $Filepath"

        $ini = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)

        if (!(Test-Path $Filepath))
        {
            Write-Verbose ("Warning: `"{0}`" was not found." -f $Filepath)
            return $ini
        }

        $commentCount = 0
        switch -regex -file $FilePath
        {
            "^\s*\[(.+)\]\s*$" # Section
            {
                $section = $matches[1]
                Write-Verbose "$($MyInvocation.MyCommand.Name):: Adding section : $section"
                $ini[$section] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
                $CommentCount = 0
                continue
            }
            $commentRegex # Comment
            {
                if (!$IgnoreComments)
                {
                    if (!(test-path "variable:local:section"))
                    {
                        $section = $script:NoSection
                        $ini[$section] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
                    }
                    $value = $matches[1]
                    $CommentCount++
                    Write-Debug ("Incremented CommentCount is now {0}." -f $CommentCount)
                    $name = "Comment" + $CommentCount
                    Write-Verbose "$($MyInvocation.MyCommand.Name):: Adding $name with value: $value"
                    $ini[$section][$name] = $value
                }
                else { Write-Debug ("Ignoring comment {0}." -f $matches[1]) }

                continue
            }
            "(.+?)\s*=\s*(.*)" # Key
            {
                if (!(test-path "variable:local:section"))
                {
                    $section = $script:NoSection
                    $ini[$section] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
                }
                $name,$value = $matches[1..2]
                Write-Verbose "$($MyInvocation.MyCommand.Name):: Adding key $name with value: $value"
                $ini[$section][$name] = $value
                continue
            }
        }
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Finished Processing file: $FilePath"
        Return $ini
    }

    End
        {Write-Verbose "$($MyInvocation.MyCommand.Name):: Function ended"}
}
Set-Alias gic Get-IniContent


$ini_content  = Get-IniContent ".\testing.ini"
$memory_card  = $ini_content["Variables"]["memory_card2"]

Write-Host "$memory_card"






# # Set Variables - For easy changing later
#   # USER VARIABLES
#     # $memory_card          = "D:\#Data\!Pictures\!Photographs\Aerial\testing_card"
#     $memory_card        = "k:\dcim"
#     $file_types           = @("dng", "jpg", "jpeg")    

#   # Housekeeping Variables
#     $opcode_files         = New-Object System.Collections.Generic.List[System.Object]
#     $total_files          = 0
#     $total_files_of_type  = 0
#     $total_opcode_files   = 0
#     $files_counter        = 0
#     $opcode_files_counter = 0
    
#   # Get count of total_files of the types we're looking for so we can display progress
#   foreach ($file_type in $file_types) {
#     $total_files_of_type = Get-ChildItem "$memory_card" -recurse -file -Filter *.$file_type
#     $total_files = $total_files + $total_files_of_type.count
#   }    

# # Loop through all of the file_types on the card. Grabs all of the files of each file_type
# # For reach file we're checking the camera model and serial numbers to assign codes for renaming
# # Also want the model so we can strip  -opcodes3 from Phantom 4 Pro DNG files to clear lens profile
#   foreach ($file_type in $file_types) {
#     $files = Get-ChildItem "$memory_card" -recurse -file -Filter *.$file_type | Select -exp fullname
#     foreach ($file in $files) {
#       # Progress counter
#       $files_counter++

#       $camera = exiftool -model $file
#       switch -wildcard ($camera)
#       {
#         "*FC6310" {$camera_code = "P4P"}
#         "*FC220"  {$camera_code = "M1P"}
#         default   {$camera_code = ""}
#       }
      
#       $serial = exiftool -SerialNumber $file
#       switch -wildcard ($serial)
#         # To add/remove/change individual cameras, change the serial number on the left and corresponding name on the right
#         # Be sure to keep the * as a wildcard at start and end so it matches the exiftool output.
#         {
#           "*944c5c7ca3aa24ee43b43f2c7e129a7*" {$camera_actual = "P4P-02"}
#           "*2014031100*"                      {$camera_actual = "MV1-03"}
#           $null                               {$camera_actual = $camera_code}
#           default                             {$camera_actual = $camera_code}
#         }
      
#       if ($file_type -eq "dng" -AND $camera_code -eq "P4P") {
#         # If a DNG file from a Phantom 4 Pro camera, saving the file into an array so we can strip off the opcodes
#         # Doing this instead of stripping at the time of copy b/c it slows down the copy & so multiple cards is slower
#         $opcode_files.add($file)
#         $total_opcode_files++
#       }
#       exiftool -r -m -o . -v3 -d "%Y\%Y-%m-%d - [$camera_actual]\%Y%m%d-$camera_code--%%f.%%e" "-filename<createdate" $file | tee-object -append -file .\exiftoollog--all.txt | Out-File .\exiftoollog-_last.txt

#       Write-Host "---------------------------------"
#       Write-Host "Copied:             $files_counter/$total_files"
#       Write-Host "Profile Nuke Queue: $total_opcode_files"
#     }    
#   }
#   Write-Host "---------------------------------"
#   Write-Host ""
#   Write-Host "All Files Copied, Renamed, and Sorted"
#   Write-Host ""
#   Write-Host "!!! You can safely remove the memory card !!!"
#   Write-Host ""
#   Write-Host "---------------------------------"
#   Write-Host "Beginning to strip -OpCode3 from total of $total_opcode_files P4P DNG files"
#   Write-Host ""
#   $opcode_files.ToArray() | tee-object -append -file .\exiftoollog--all.txt | Out-File -append .\exiftoollog-_last.txt
#   foreach ($opcode_file in $opcode_files) {
#     $opcode_files_counter++
#     exiftool.exe -OpcodeList3= -m -overwrite_original -progress -v3 $opcode_file | tee-object -append -file .\exiftoollog--all.txt | Out-File -append .\exiftoollog-_last.txt      
#       Write-Host "-Opcode3 Removed:   $opcode_files_counter/$total_opcode_files" 
#   }
#   Write-Host "---------------------------------"
#   Write-Host ""
#   Write-Host ""
#   Write-Host "$files_counter of $total_files copied"
#   Write-Host "$opcode_files_counter of $total_opcode_files P4P DNG Profiles stripped"
#   Write-Host "See exiftoollog--last.txt for detailed logs of current import"
#   Write-Host "See exiftoollog--all.txt for detailed logs of import history"
#   Write-Host ""
#   Write-Host "Now, go make some cool shit"
#   Write-Host ""
#   Write-Host ""
#   Write-Host "---------------------------------"
#   Pause