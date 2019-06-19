#!/bin/bash


IFS='/'
read -ra ARR <<< "$1"
IFS=""

name=${ARR[-1]}
mkdir $name
cd $name

mkdir samples
cd samples
sampleslink="/file/statement/samples.zip"
samples=$1$sampleslink
wget -q $samples

unzip -qq samples.zip
rm -rf samples.zip
cd ..

touch $name".py"
code="import sys

def $name(lines):
    pass


def main():
    lines = [line.strip() for line in sys.stdin]
    print($name(lines))
main()"
echo $code > $name".py"
echo "Problem extracted to ./$name/"
