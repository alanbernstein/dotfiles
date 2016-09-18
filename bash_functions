# https://sift-tool.org/docs
grep_sift ()
{
    echo "using sift instead of grep"
    sift $*
}
# alias grep="grep_sift"
# alias egrep="grep_sift"


# https://gist.github.com/petruisfan/b0e57db048483a69e81e
cd_autoenv ()
{
# note that you will need to use \cd at the CLI to use any other flags
    \cd -P "$*"  # instead of $1, so it works with space in name
    if [[ -e .env ]]; then
        echo "sourcing ./.env"
        source .env
    fi
}
#alias cd="cd_autoenv"  # do this in .alias instead


pyj ()
{
# pretty print a json file
# if none supplied, pick the most-recently one changed in pwd
  if [ "$#" -eq 0 ] ; then
    file=$(\ls *.json -t1 | head -1)
    echo "found $file..."
  else
    file=$1
  fi
  cat $file | python -m json.tool
}

n ()
{
  echo "${*}" >> $DROPBOX/notes.txt;
}

cmdedit ()
{
# open in an editor, a file that is on the path
  cmd_path=$(which $1)
  real_path=$(readlink -f $cmd_path)
  emacsclient -n $real_path
}

echopath ()
{
  echo $1 | tr : "\n"
}

backup()
{
# cp name.ext name.bak.ext
  for i do
    case ${i##*/} in
      (?*.?*) cp -iv -- "$i" "${i%.*}.bak.${i##*.}";;
      (*) cp -iv -- "$i" "$i.bak"
    esac
  done
}

## old junk

subopen ()
{ 
# open all files matching a search string in sublime
# ask for permission if >10 files or something
# todo: allow specifying a number to open at the yn prompt
    num_matches=$(pygrepwithtest $1 | cut -d: -f1 | sort | uniq | wc -l)
    if [ "$num_matches" -gt "10" ] ; then
        read -p "$num_matches matches, are you sure? " yn

        case $yn in
            [Yy]* ) open='true' ;;
            [Nn]* ) open='false' ;;
            * ) echo "??" ;;
        esac
    fi

    if [ "$open" = "true" ] ; then
        for f in $(pygrep $1 | cut -d: -f1 | sort | uniq) ; do
            sublime $f
            echo $f
        done
    fi
}


sssh ()
{
# http://stackoverflow.com/questions/305035/how-to-use-ssh-to-run-shell-script-on-a-remote-machine
ssh $1 <<'ENDSSH'
alias l='ls -la'
ENDSSH
}


ds ()
{
  if [[ $# == 0 || $1 == "-h" ]] ; then 		# display history
    cat -n ~/.cdhist
  elif [[ $1 == "-n" ]] ; then  				# cd to directory #k
    echo "cding to" $(head -$2 ~/.cdhist | tail -1)
    cd $(head -$2 ~/.cdhist | tail -1)
  elif [[ $1 == "-l" ]] ; then  				# load default
    cat ~/.cdrc > ~/.cdhist ;
  elif [[ $1 == "-c" ]] ; then  				# clear history
    echo "" > ~/.cdhist ;
  elif [[ $1 == "-s" ]] ; then  				# save default
    cat ~/.cdhist > ~/.cdrc ;
  else                          				# add PATH to history, keep history file chronological, cd to PATH
    echo $1 >> ~/.cdhist ;                       # append to history file
    nl ~/.cdhist | sort -r | cut -f2 > ~/.cdtmp  # reverse lines
    awk '!($0 in a) {a[$0];print}' ~/.cdtmp > ~/.cdhist  # remove duplicates, keeping only the first (which is really the last)
    nl ~/.cdhist | sort -r | cut -f2 > ~/.cdtmp  # reverse lines again
    cat ~/.cdtmp > ~/.cdhist                     # move from temp file to real file
    rm ~/.cdtmp                                  # get rid of temp file
    cd $1 ;
  fi ;
}

