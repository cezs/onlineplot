#!/bin/sh

sed -e 's/RAM //' -e 's/(lfb //' -e 's/\// /' -e 's/x/ /' -e's/)//' -e's/MB//g' -e's/cpu \[//' -e's/%//g' -e's/,/ /g' -e's/@/ /g' -e's/\]//g' -e's/GR3D //' -e's/EDP //' -e's/ limit 0//' 
