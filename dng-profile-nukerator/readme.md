# Phantom 4 Pro DNG Profile EXIF documentation

## About
Details about the EXIF tags that contain all of the DJI _embedded profile_ that performs destructive changes to the DNG files when edited with Adobe tools. 

## EXIF Tags

Stripped tags. To remove all of these tags from the RAW file, run the command:

exiftool -CalibrationIlluminant1= -CalibrationIlluminant2= -ProfileHueSatMapDims= -ProfileHueSatMapData1= -ProfileHueSatMapData2= -ProfileEmbedPolicy= -NoiseProfile= -DefaultScale= -DefaultCropOrigin= -DefaultCropSize= -BayerGreenSplit= -AntiAliasStrength= -BestQualityScale= -ActiveArea= -OpcodeList1= -OpcodeList3= -DefaultUserCrop= -YCbCrCoefficients= -YCbCrSubSampling= -YCbCrPositioning= -ReferenceBlackWhite= -make= -model= -makernotes:all= \*.dng

### CalibrationIlluminant1
CalibrationIlluminant1
### CalibrationIlluminant2
CalibrationIlluminant2
### ProfileHueSatMapDims
ProfileHueSatMapDims
### ProfileHueSatMapData1
ProfileHueSatMapData1
### ProfileHueSatMapData2
ProfileHueSatMapData2
### ProfileEmbedPolicy
ProfileEmbedPolicy
### NoiseProfile
NoiseProfile
### DefaultScale
DefaultScale
### DefaultCropOrigin
DefaultCropOrigin
### DefaultCropSize
DefaultCropSize
### BayerGreenSplit
BayerGreenSplit
### AntiAliasStrength
AntiAliasStrength
### BestQualityScale
BestQualityScale
### ActiveArea
ActiveArea
### OpcodeList1
OpcodeList1
### OpcodeList3
Contains Binary data. Seems to be most responsible for the cropping of the file.
### DefaultUserCrop
DefaultUserCrop
### YCbCrCoefficients
YCbCrCoefficients
### YCbCrSubSampling
YCbCrSubSampling
### YCbCrPositioning
YCbCrPositioning
### ReferenceBlackWhite
ReferenceBlackWhite