#!/usr/bin/env bash
#
#
#

function print_help() {
help="
Usage: ./$0 <options>

Available options:
  --name=\"<search pattern>\"
          Names for the files to rotate. Could be '*.log' or a regular expression.

  --source=\"source_dir\"
          Source directory where to look for files. If not specified, current directory is used.

  --destination=\"[destination dir]\"
          Destination directory to move files to. If not specified, files are compressed within the directory specified with '--source'.

  --older-than=[days]
          Number of days to keep files. Files older days than this number will be deleted. When not specified, keep forever.

  --check
          If set, do not perform actual actions, rather show what would be done.

"

echo "$help"
}


S_TYPE=$( uname -s )
[ "$S_TYPE" = "Windows_NT" ] && NULL_DEV=NUL || NULL_DEV=/dev/null

# Exit and print help when no args specified
[ $# -eq 0 ] && { echo "No arguments supplied."; print_help;  exit 1; }

# Reading arguments here
for i in "$@"
do
        case $i in
            -h|--help)
            print_help
            ;;
            --name=*)
            NAME_PATTERN="${i#*=}"
            shift # past argument=value
            ;;
            --source=*)
            SRC_DIR="${i#*=}"
            shift # past argument=value
            ;;
            --destination=*)
            DST_DIR="${i#*=}"
            shift # past argument=value
            ;;
            --older-than=*)
            OLDER_THAN="${i#*=}"
            shift # past argument=value
            ;;
            --check)
            CHECK_FLAG="True"
            shift # past argument=value
            ;;
            *)
                 # unknown option
                 printf "Unknown option $i\n"
            ;;
        esac
done

[ -z "$SRC_DIR"  ] && { echo "Source directory ( --source=<source_dir> ) is mandatory."; exit 1; }

# Strip trailing slash from the dir
SRC_DIR=${SRC_DIR%/}

# Set DST_DIR the same as SRC_DIR if not set as a pramaeter.
DST_DIR=${DST_DIR:-$SRC_DIR}

MINUTES=${OLDER_THAN:+$(( $OLDER_THAN * 1440 ))}

# Add -mtime option if --older-than is set.
OPT_MMIN=${OLDER_THAN:+"-mmin +$MINUTES"}

# Add name matching if --name is set.
OPT_NAME=${NAME_PATTERN:+"-name $NAME_PATTERN"}

for filepath in $( find $SRC_DIR -type f -maxdepth 1 $OPT_MMIN $OPT_NAME )
do
   if [ -z "$CHECK_FLAG" ]; then
      gzip --best -c $filepath > ${DST_DIR}/${filepath##*/}.gz && \
      rm -f $filepath
   else
      printf "gzip --best -c $filepath > ${DST_DIR}/${filepath##*/}.gz && rm -f $filepath\n"
   fi
done
