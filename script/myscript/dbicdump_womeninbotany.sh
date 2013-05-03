dbicdump  -o dump_directory=./lib/  -o components='[qw(InflateColumn::DateTime TimeStamp PassphraseColumn)]' \
-o use_moose=1 -o overwrite_modifications=1 -o preserve_case=1 \
-o moniker_map='{users_roles =>  "UserRole",botanists_links => "BotanistLink",botanists_references=>"BotanistReference"}' \
-o debug=1 WomenInBotany::Schema 'dbi:mysql:database=womeninbotany' womeninbotany <fill password in>
