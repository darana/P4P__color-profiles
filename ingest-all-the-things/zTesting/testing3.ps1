$regex1 = [regex] '.*'
$regex2 = '(?<=--> '').*(?=\'')'
$input_file = '.\ingest__log--last.txt'
$output_file = '.\testing3.txt'

# select-string -path $input_file -Pattern $regex2 -AllMatches | % { $_.Matches } | % { $_.Value }
$output_files = select-string -Path $input_file -Pattern $regex2 -AllMatches | % { $_.Matches } | % { $_.Value }
$output_files
# write-host "$regex1"

