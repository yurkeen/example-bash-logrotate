# example-bash-logrotate
Example bash script for logs rotation/archivation.

## how to use

Usage: ./logrotate.sh <options>
Available options:
  --name="<search pattern>"
          Names for the files to rotate. Could be '*.log' or a regular expression.
  --source="source_dir"
          Source directory where to look for files. If not specified, current directory is used.
  --destination="[destination dir]"
          Destination directory to move files to. If not specified, files are compressed within the directory specified with '--source'.
  --older-than=[days]
          Number of days to keep files. Files older days than this number will be deleted. When not specified, keep forever.
  --check
          If set, do not perform actual actions, rather show what would be done.

