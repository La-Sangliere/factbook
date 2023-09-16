#! /bin/ksh
#! @brief Removes all dupplicates creating symbolic links in the `shared` directory
#! This will source a file named %.out that executes function process passing all same files as it arguments
#! The %.out file is constructed from the %.in file (manually); this latter is simply the output of cksum(1)

# Initialise defaults
integer -s ftotal fdupps funiq
integer    btotal bdupps buniq

typeset cwd=$PWD
print "DISK USAGE BEFORE: $(du -sh .)"

function process {

    # Make sure we are in the correct directory
    cd "$cwd"

    # Do the base maths
    integer x=$(stat -f%z "$1") y=$#-1; (( ftotal += y, funiq += 1, fdupps += y, buniq += x, bdupps += x * y ))

    typeset count=0 path; for path in "$@"; do

        typeset dir="${path%/*}" file="${path##*/}" ext="${file##*.}"; [[ $ext == $file ]] && unset ext

        typeset name; while true; do name=shared/$(euid)${ext:+.$ext}; [[ -f $name ]] || break; done
        typeset rpath="${dir//+([!\/])/..}/$name"

        cd "$cwd/$dir"; (( count ++ == 0 )) && mv "$file" $rpath || rm "$file"; ln -s $rpath "$file"

    done

}

# Load list of files to be processed
source ./lndupps.out

# Summarise what we have saved
integer x mbdupps mbuniq mbtotal; (( x = 1024 * 1024, btotal = buniq + bdupps, mbdupps = bdupps / x, mbuniq = buniq / x, mbtotal = btotal / x ))
printf 'Found %d/%d dupplicate files, reduced to %d unique files\n' $fdupps $ftotal $funiq
printf 'This process saved %d/%d MB, the %d unique files now representing %d MB\n' $mbdupps $mbtotal $funiq $mbuniq
cd "$cwd"; print "DISK USAGE AFTER: $(du -sh .)"

#! @revision 2023-09-16 (Sat) 10:20:29
