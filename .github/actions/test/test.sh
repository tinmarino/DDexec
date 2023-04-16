#!/bin/sh

# Usage: `bash test.sh` (only supported shell for this script is bash)

# TODO
# Add timing report
# Add function equal with color for report

exit_status=0

shellcode_base64="4831ff5766ffc748b86f20776f726c640a50b848656c6c48c1e02050488"\
"9e64883c6044889f84889c2b20c0f054831c04889c7b03c0f05"
shellcode_binary=$(printf "%s" "$shellcode_base64" | sed 's/\([0-9A-F]\{2\}\)/\\x\1/gI')

# DDexec echo
ret=$(base64 -w0 "$(which echo)" |\
     "$1" ddexec.sh echo -n asd qwerty "" zxcvb " fdsa gf")
if [ "$ret" = "$(echo -n asd qwerty "" zxcvb " fdsa gf")" ]
then
    echo "bash + ddexec, test 1: OK"
else
    echo "bash + ddexec, test 1: Error :("
    exit_status=1
fi

# DDsc shellcode
ret=$(echo $shellcode_base64 | "$1" ddsc.sh -x)
if [ "$ret" = "Hello world" ]
then
    echo "bash + ddsc, test 1: OK"
else
    echo "bash + ddsc, test 1: Error :("
    exit_status=1
fi

# DDsc shellcode bin
ret=$(printf "$shellcode_binary" | "$1" ./ddsc.sh)
if [ "$ret" = "Hello world" ]
then
    echo "bash + ddsc, test 2: OK"
else
    echo "bash + ddsc, test 2: Error :(, got $ret!"
    exit_status=1
fi
echo

exit $exit_status
