if [ -z "$1" ]; then 
    echo usage: $0 Password
    exit
fi
PASSWD=$1
dbicdump  -o dump_directory=./lib/  -o components='[qw(InflateColumn::DateTime TimeStamp PassphraseColumn InflateColumn::FS)]' \
-o use_moose=1 -o overwrite_modifications=1 -o preserve_case=1 \
-o moniker_map='{users_roles => "UserRole",botanists_links => "BotanistLink", botanists_references=>"BotanistReference",botanists_categories=>"BotanistCategory"}' \
-o debug=1 WomenInBotany::Schema 'dbi:mysql:database=womeninbotany' womeninbotany $PASSWD 

