#!/bin/bash
hexchars="0123456789ABCDEF"
end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
echo upper = 52:54:00$end
echo lower = 52:54:00$end | tr '[:upper:]' '[:lower:]'
