# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
- Video file ingest with rename & sort and stuff
- Update Exiftool commands to use native Exiftool conditionals, possibly with ARG files, to allow Exiftool to run in parallel

## [0.5] - 2017-11-20
### Added
- Ingest functionality for image files
- Added, uh, a changelog

### Changed
- Updated file structures, renamed top level folders to better represent what they evolved into
- Reorganized and updated readme.md a bit to better communicate the different portions of this repo
- Cleaned up straight nukerator scripts, now they log the output to files and just give status on the screen instead of massive, unreadable spam.
- Added -m to Exiftool in all uses to suppress offset errors.
- Moved older versions of script files and windows batch version into ingest-all-the-things\zLegacy

### Removed
- n/a

## [0.1] - 2017-09-22
### Added
- Everything up until this point, rough versions of files

### Changed
- Before, there was nothing. Now, there is something. That, my friends, is a change.