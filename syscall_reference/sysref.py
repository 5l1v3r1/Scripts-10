#!/usr/bin/env python
#
# A simple console interface for SYSCALL Referencing
# by:    @_x90__
#
# Thanks must go out to http://syscalls.kernelgrok.com/ as
# the data for sys call references has come from this site!
# (Greg Ose)
#
# It has been created so that if you are without internet connection
# Or you simply wish to reference syscalls without a browser
# you can do so with your command line.
#
###########################################################

import sys

def main():
    reference = list()
    columns = ["#", "Name", "eax", "ebx", "ecx", "edx", "esi", "edi", "Definition"]

    print("+======> Unix 32_bit syscall reference <======+")
    print("________________________________________ ~\\x90__")

    with open("syscall_data.lst", "r") as f:
        for i in f.read().split("\n"):
            reference.append(i.split("\t"))

    while True:
        syscall = raw_input("\033[1;92msyscall # or alias #\033[0m ")
        try:
            if int(syscall) >= 0 and int(syscall) < 338:
                num = 0
                for i in reference[int(syscall)]:
                    print("\033[1;94m" + columns[num] + "\033[0m : " + i)
                    num += 1
        except:
            pass


if __name__ == '__main__':
    try:
        main()
    except(KeyboardInterrupt):
        print("")
