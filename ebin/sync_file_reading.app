{application, 'sync_file_reading', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['file_reader','ping_handler','readfile_handler','sync_file_reading_app','sync_file_reading_sup']},
	{registered, [sync_file_reading_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {sync_file_reading_app, []}},
	{env, []}
]}.