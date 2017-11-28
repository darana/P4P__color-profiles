# Phantom 4 Pro DNG File Management
DJI Phantom 4 Pro (& others) color & lens profiles, importer & file renamer, and optional embedded lens profile nukeration. [Original repo on GitHub](https://github.com/darana/P4P__color-profiles)

- [P4P DNG Color Profiles](##p4p-dng-color-profiles)
- [Ingest with Embedded Lens Nukerationizer for DNG](#ingest-with-embedded-lens-nukerationizer-for-dng)
- [Profile Nukerationizers](#profile-nukerationizernameprofile-nuke)
- [P4P DNG Profile EXIF documentation](#p4p-dng-profile-exif-documentationnameexif-info)

## P4P DNG Color Profiles

#### About
Custom Color Profiles for the DJI Phantom 4 Pro. Created using an [XRite Color Checker Passport](http://xritephoto.com/colorchecker-passport-photo)

#### Download
Download [P4P-color_profiles.zip](https://github.com/darana/P4P__color-profiles/blob/master/p4p-color-profiles/P4P-color_profiles.zip) or clone the repo

#### Installation

###### Windows
- Unzip all of the .dcp files into C:\users\\%yourprofile%\AppData\Roaming\Adobe\CameraRaw\CameraProfiles

###### OSX
- ¯\\_(ツ)_/¯ No More thanks to [@Ravedog](https://phantompilots.com/members/ravedog.88118/) at PhantomPilots.com
- (users Library folder)
- ~/Library/Application Support/Adobe/Camera Raw/CameraProfiles/
- There is another repository for the profiles at the root Library folder on a startup drive:
- /Library/Application Support/Adobe/Camera Raw/CameraProfiles/


## Phantom 4 Pro Lens Profile
Lens profile & documentation by [@Dingoz](https://phantompilots.com/members/dingoz.97597/) on [PhantomPilots.com](https://phantompilots.com/threads/phantom-4-pro-adv-lightroom-lens-profile.124119/#post-1266093)

#### About
Here are Lightroom/Photoshop/Camera Raw lens profiles (RAW+JPG versions). These are only for RAW files that have been stripped of the embedded lens profile (at minimum "OpCodeList3" among others as desired). It will apply lens distortion correction (almost identical to DJI's profile except retaining a larger field of view and less distortion scaling), Vignetting and Aberrations.

#### Download
Download [p4p-adobe-lens-profiles.zip](https://github.com/darana/P4P__color-profiles/blob/master/p4p-adobe-lens-profiles/p4p-adobe-lens-profiles.zip) or clone the rep

I created these from shooting actual test charts using the P4A camera (official Adobe lens profile tool). I might go back a redo another set of test charts just to compare any variations that might show or increase accuracy further (see if I can get data closer into the 4 corners) but they appear to be good to go as is anyway.

#### Installation

###### Windows
- Unzip all of the .lcp files into C:\users\\%yourprofile%\AppData\Roaming\Adobe\CameraRaw\LensProfiles\1.0

###### OSX
- ¯\\_(ツ)_/¯ No More thanks to [@Ravedog](https://phantompilots.com/members/ravedog.88118/) at PhantomPilots.com
- (users Library folder)
- ~/Library/Application Support/Adobe/Camera Raw/LensProfiles/1.0/DJI/
- There is another repository for the profiles at the root Library folder on a startup drive:
- /Library/Application Support/Adobe/Camera Raw/LensProfiles/1.0/DJI/


## Ingest with Embedded Lens Nukerationizer for DNG

#### About
Powershell script to simplify what becomes a multi-stage ingest process when pulling files off memory cards, in particular when removing the built-in DNG Lens Profile. Typical ingest process with Lightroom would pull files off the card and start creating thumbnails, all of which gets thrown out and requires additional metadata synchronization after removing the DNG Lens Profiles.

In addition, versions for video allow parallel ingesting of video and stills off the same card. Video ingest is a whole other crazy sauce for those used to stills ingest.

Both tools designed to ingest files using Exiftool to sort & rename into appropriate directories ready to be directly imported in situ with your library/editor of choice.

There's plenty still hard coded here, basically to my preferences. Variables to change if you want

- \# USER VARIABLES at the top has definition for memory card path and all of the file types to grab
- 'switch -wildcard ($camera)' looks for matching $exif:model codes and defines a shortcode. This shortcode is included in the filename
- 'switch -wildcard ($serial)' looks for matching $exif:SerialNumber values and defines a shortcode. This shortcode is used in the directory name.
- Folder structure is YEAR\YEAR-MONTH-DAY - [CAMERA_ACTUAL_SHORTCODE]\YEARMONTHDAY-[CAMERA_SHORTCODE]--ORIGINAL_FILENAME.ORIGINAL_EXTENSION See [ExifTool File Rename help page](https://www.sno.phy.queensu.ca/~phil/exiftool/filename.html) for info on the variables.

#### Installation

###### Windows
- Grab the powershell scripts
- [All scripts require ExifTool. See site for binaries.](https://www.sno.phy.queensu.ca/~phil/exiftool/)
- Put them somewhere
- Ideally put them somewhere in your path, put that somewhere in your path, or just put it where you're going to run it.
- You'll probably need to change your execution policy. Although probably not, if you're actually grabbing powershell scripts from GitHub



###### OSX
- Uh, it's written in Powershell, sooooo ¯\\_(ツ)_/¯

## Profile Nukerationizer

#### About
Basic issue is that the DJI RAW files (dng format) have an embedded profile that can not be altered from within Adobe editing tools. This profile introduces some compromises that we may not always want to accept.

All of the components of this embedded profile are defined within the EXIF data of the DNG file. So by changing or clearing the right EXIF tags we can effectively remove the embedded profile and start at the beginning.

Thanks in particular to Dingoz and GMack on PhantomPilot.com for their contributions and testing! See the full thread on [PhantomPilots.com](https://phantompilots.com/threads/nuking-the-dng-camera-profile.120302/) for further discussion and rambling!

#### The Command
Want to just run it yourself? Grab [Exiftool](https://www.sno.phy.queensu.ca/~phil/exiftool/) and run the command:

`exiftool.exe -OpcodeList3= -m -overwrite_original -progress -v3 -ext DNG -if "$EXIF:OpcodeList3 ne ''" FILENAME\PATH`

Syntax:
- Runs `Exiftool` program and `-OpcodeList3=` sets that field to null, i.e. deleting it.
- `-m` suppresses low priority warnings. There is a message about offset that will come up for every single file, otherwise.
- `overwrite original` well, overwrites your original
- `-ext DNG` tells the command only to run against DNG files, whether you specify a filename or a folder/path
- `-progress` and `-v3` provide detailed progress and logging
- `-if "$EXIF:OpcodeList3 ne ''"` makes the command conditional, running against the file only if the file's -OpcodeList3 isn't already blank. This is optional, I just use it to speed things up in the case where I have already run against part of the list.
- `FILENAME\PATH` is the filename or the folder of files to execute against.



#### Download
This is very much still a work in progress. You can use the batch file _dngnukerator.bat_ to aggressively strip all of the settings that could be part of the embedded profile. Testing continues to identify with certainy which EXIF tags definitely contain that the embedded profile.

[All scripts require ExifTool. See site for binaries.](https://www.sno.phy.queensu.ca/~phil/exiftool/)

## P4P DNG Profile EXIF documentation

### About
Details about the EXIF tags that contain all of the DJI _embedded profile_ that performs destructive changes to the DNG files when edited with Adobe tools.

### EXIF Tags

Stripped tags. To remove all of these tags from the RAW file, run the command:

exiftool -CalibrationIlluminant1= -CalibrationIlluminant2= -ProfileHueSatMapDims= -ProfileHueSatMapData1= -ProfileHueSatMapData2= -ProfileEmbedPolicy= -NoiseProfile= -DefaultScale= -DefaultCropOrigin= -DefaultCropSize= -BayerGreenSplit= -AntiAliasStrength= -BestQualityScale= -ActiveArea= -OpcodeList1= -OpcodeList3= -DefaultUserCrop= -YCbCrCoefficients= -YCbCrSubSampling= -YCbCrPositioning= -ReferenceBlackWhite= -make= -model= -makernotes:all= \*.dng

#### CalibrationIlluminant1
CalibrationIlluminant1
#### CalibrationIlluminant2
CalibrationIlluminant2
#### ProfileHueSatMapDims
ProfileHueSatMapDims
#### ProfileHueSatMapData1
ProfileHueSatMapData1
#### ProfileHueSatMapData2
ProfileHueSatMapData2
#### ProfileEmbedPolicy
ProfileEmbedPolicy
#### NoiseProfile
NoiseProfile
#### DefaultScale
DefaultScale
#### DefaultCropOrigin
DefaultCropOrigin
#### DefaultCropSize
DefaultCropSize
#### BayerGreenSplit
BayerGreenSplit
#### AntiAliasStrength
AntiAliasStrength
#### BestQualityScale
BestQualityScale
#### ActiveArea
ActiveArea
#### OpcodeList1
OpcodeList1
#### OpcodeList3
Contains Binary data. Seems to be most responsible for the cropping of the file.
#### DefaultUserCrop
DefaultUserCrop
#### YCbCrCoefficients
YCbCrCoefficients
#### YCbCrSubSampling
YCbCrSubSampling
#### YCbCrPositioning
YCbCrPositioning
#### ReferenceBlackWhite
ReferenceBlackWhite