# Set Variables - For easy changing later
    $memory_card                    =   "D:\#Data\!Pictures\!Photographs\Aerial\testing_card"
    # $memory_card                    =   "k:\dcim"
    $file_types               =   @("dng", "jpg", "jpeg")

# Select the name and the extension of the first file in the directory
# If it is a picture file, stills & videos have a different EXIF code
# to find the type of camera. Also the videos don't have serial #s so skip that

    foreach ($file_type in $file_types) {    
        $files = Get-ChildItem "$memory_card" -recurse -file -Filter *.$file_type | Select -exp fullname
        foreach ($file in $files) {
            $camera = exiftool -model $file
            $camera = $camera.TrimStart("Camera Model Name               : ")
            switch ($camera)
            {
                FC6310  {$camera_code = "P4P"}
                FC220   {$camera_code = "M1P"}
                default {$camera_code = ""}
            }
            if ($model -eq "UniqueCameraModel") {
                $serial = exiftool -CameraSerialNumber $file
                $serial = $serial.TrimStart("Camera Serial Number            : ")
                switch ($serial)
                    {
                        c44879200a2f1322b12d25c3b858163         {$camera_actual = "P4P-02"}
                        bc44879200a2f1322b12d25c3b858163        {$camera_actual = "MV1-03"}
                        default                                 {$camera_actual = ""}
                    }
            }
            exiftool -r -o . -v3 -d ztemp\%Y%m%d-$camera_code--%%f.%%e "-filename<createdate" $file | tee-object -append -file .\exiftool_copy_log.txt


        }
    }


# Select the name and the extension of the first file in the directory
# If it is a picture file, stills & videos have a different EXIF code
# to find the type of camera. Also the videos don't have serial #s so skip that

# $first_file = Get-ChildItem | Select-Object -First 1 | Select -exp Name
# $first_file = Get-ChildItem "$memory_card" -recurse -file | Select-Object -First 1 | Select -exp fullname
# $first_file_extension = Get-ChildItem "$memory_card" -recurse -file| Select-Object -First 1 | Select -exp Extension
# switch ($first_file_extension)
#     {
#         .dng {$model = "UniqueCameraModel"}
#         .jpg {$model = "UniqueCameraModel"}
#         .mp4 {$model = "Model"}
#         .mov {$model = "Model"}
#     }
#     Write-Host "$model"
# # Grab the camera model, strip the prefix, then match it to the switch table
# # Use this to define the generic camera code
# $camera = exiftool -$model $first_file
# $camera = $camera.TrimStart("Unique Camera Model             : ")
# switch ($camera)
#     {
#         FC6310  {$camera_code = "P4P"}
#         FC220   {$camera_code = "M1P"}
#         default {$camera_code = ""}
#     }
# # Grab the camera model, strip the prefix, then match it to the switch table
# # Use this to define the specific camera code
# if ($model -eq "UniqueCameraModel") {
#     $serial = exiftool -CameraSerialNumber $first_file
#     $serial = $serial.TrimStart("Camera Serial Number            : ")
#     switch ($serial)
#         {
#             c44879200a2f1322b12d25c3b858163         {$camera_actual = "P4P-02"}
#             bc44879200a2f1322b12d25c3b858163        {$camera_actual = "MV1-03"}
#             default                                 {$camera_actual = ""}
#         }
# }
# # TESTING output
#     Write-Host "$camera"
#     Write-Host "$camera_code"
#     Write-Host "$serial"
#     Write-Host "$camera_actual"
