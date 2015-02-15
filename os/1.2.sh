#!/bin/bash

rename_file()
{
	file=$1
	echo $file
}

cd test_1_2

for File in *
do
	rename_file $File
done

exit 0