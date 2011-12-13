#!/bin/sh

set -e

echo ""
echo "build vimproc (post-merge hook)"
echo ""

HOOK_DIR=`dirname $0`
PROC_DIR="$HOOK_DIR/../.."

case `uname -s` in
Linux)
	MAKE_FILE='make_gcc.mak'
	PROC_FILE='proc.so'
	;;
*)
	echo "error: not supported OS"
	exit 1
	;;
esac

cd $PROC_DIR

if [ -f autoload/$PROC_FILE ]; then
	echo "delete old $PROC_FILE"
	rm autoload/$PROC_FILE
	echo "done"
	echo ""
fi

echo "compile new $PROC_FILE"
make -f $MAKE_FILE
echo "done"
echo ""

echo "vimproc was updated"
