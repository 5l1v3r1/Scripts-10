#!/usr/bin/env awk -f
#
#  Author: Spacecow
#  Date: 19/10/2014
#  Description:
#  Give output pretty line numbers :D


BEGIN {
	num = 0;
	space = " ";
}

{
	num++;
	if (num < 10) {
		print "    " num "   " $0;
	} else {
		print "    " num "  " $0;
	}
}

#END {
#	num++;
#	print num " "
#}
