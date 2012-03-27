# gen_linux_makefiles.sh	:	shell script to generate most of the project linux makefiles from the osx ones

LUA=$HOME/swtools/lua/bin/lua

infiles=(\
 "Makefile" \
 "util/Makefile" \
 "gl/Makefile" \
 "glu/Makefile" \
 "glfw/Makefile" \
 "img/Makefile" \
 "font/Makefile" \
 "edit/Makefile" \
 ""
)
convert="gen_linux_from_osx_makefile.lua"
i=0
infile=${infiles[$i]}
while [ -n "$infile" ]; do
	in_make="../$infile.osx"
	out_make="../$infile.linux"
	$LUA $convert $in_make > $out_make
	if [ $? -ne 0 ]; then
		echo "error: failed converting $in_make: $?"
		exit 1
	fi

	i=$((i+1))
	infile=${infiles[$i]}
done

