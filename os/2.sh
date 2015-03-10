#!/bin/bash

# Переименование файлов

directory=${1-"."}

cd $directory

for file in *
do
	len=${#file}
	year_idx=$(expr index $file "[0123456789]")

	if [ $year_idx -eq 0 ]; then continue; fi;

	prefix=$(expr substr $file 1 $(($year_idx-1)) | tr 'a-z' 'A-Z')
	year=$(expr substr $file $year_idx 4)
	year=${year#0}; year=${year#0}; year=${year#0}
	year=$((($year+1)%10000))
	other=$(expr substr $file $(($year_idx+4)) $(($len-$year_idx-4+1)))

	new_file=$(printf "%s%04d%s" $prefix $year $other)

	mv $file $new_file
done 