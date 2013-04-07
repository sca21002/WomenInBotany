dbicdump -o dump_directory=.\lib ^
-o components="[qw InflateColumn::DateTime TimeStamp PassphraseColumn]" ^
-o use_moose=1 -o overwrite_modifications=1 -o preserve_case=1 ^
-o moniker_map="{users_roles=>q{UserRole},botanists_refs=>q{BotanistRef}}" ^
WomenInBotany::Schema ^
dbi:mysql:database=womeninbotany womeninbotany <insert password> "{quote_char => q{`}}"
