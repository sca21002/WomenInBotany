if [ -z "$1" ]; then 
    echo usage: $0 Password
    exit
fi
PASSWD=$1
dbicdump  -o dump_directory=./lib/ \
-o use_moose=1 -o overwrite_modifications=1 -o preserve_case=1 \
-o debug=1 GND::Schema 'dbi:mysql:database=wib_mrz16;host=rzbvm013.uni-regensburg.de' atacama $PASSWD 
