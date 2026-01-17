#!/usr/bin/env bats

setup () {
  name="kounta"
  bats_require_minimum_version 1.5.0
  dir=$(dirname "$BATS_TEST_FILENAME")
  cd "$dir"
  exe="$dir/../bin/$name"
}

@test "Script syntax check" {
  run -0 perl -c "$exe"
}
@test "Version" {
  run -0 $exe --version
  [[ "$output" =~ "$name " ]]
}
@test "Help" {
  run -0 $exe --help
  [[ "$output" =~ "Build" ]]
}
@test "No parameters" {
  run ! $exe
}
@test "Bad option" {
  run ! $exe --doesnotexist
}
@test "Null input" {
  run ! $exe /dev/null
  [[ "$output" =~ "ERROR" ]]
}
@test "Full data set" {
  run $exe --kmer 7 --out /dev/stdout *.fna
  [[ "$output" =~ "KMER" ]]
  [[ "$output" =~ "AAAAAAA" ]]
  [[ "$output" =~ "NC_" ]]
}
