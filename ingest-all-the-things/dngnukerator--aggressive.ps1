exiftool.exe -CalibrationIlluminant1= -CalibrationIlluminant2= -ProfileHueSatMapDims= -ProfileHueSatMapData1= -ProfileHueSatMapData2= -ProfileEmbedPolicy= -NoiseProfile= -DefaultScale= -DefaultCropOrigin= -DefaultCropSize= -BayerGreenSplit= -AntiAliasStrength= -BestQualityScale= -ActiveArea= -OpcodeList1= -OpcodeList3= -DefaultUserCrop= -YCbCrCoefficients= -YCbCrSubSampling= -YCbCrPositioning= -ReferenceBlackWhite= -make= -model= -makernotes:all= -overwrite_original -progress -v3 -pause *.dng | tee-object -file .\exiftoollog.txt