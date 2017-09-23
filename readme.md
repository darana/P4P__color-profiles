# Phantom 4 Pro DNG Profile Management

## Custom DNG Color Profiles

### About
Custom Color Profiles for the DJI Phantom 4 Pro created using an [XRite Color Checker Passport](http://xritephoto.com/colorchecker-passport-photo)

### Download
Download [P4P-color_profiles.zip](https://github.com/darana/P4P__color-profiles/blob/master/dist/P4P-color_profiles.zip) or clone the repo

### Installation

#### Windows
Unzip all of the .dcp files into C:\users\%yourprofile%\AppData\Roaming\Adobe\CameraRaw\CameraProfiles

#### OSX
¯\\_(ツ)_/¯
#
## Embedded DJI Profile Nukerator

### About
Basic issue is that the DJI RAW files (dng format) have an embedded profile that can not be altered from within Adobe editing tools. This profile introduces some compromises that we may not always want to accept.

All of the components of this embedded profile are defined within the EXIF data of the DNG file. So by changing or clearing the right EXIF tags we can effectively remove the embedded profile and start at the beginning.

See the full thread on [PhantomPilots.com](https://phantompilots.com/threads/nuking-the-dng-camera-profile.120302/) for further discussion and rambling!

Thanks in particular to Dingoz and GMack for their contributions and efforts!

### Download
This is very much still a work in progress. You can use the batch file _dngnukerator.bat_ to aggressively strip all of the settings that could be part of the embedded profile. Testing continues to identify with certainy which EXIF tags definitely contain that the embedded profile.