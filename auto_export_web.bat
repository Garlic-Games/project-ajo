:: To run the script, it is needed to have the var env GODOT-4.3 pointing to the godot .exe and 7z available in the path
rm -r export\html
rm export\html.zip
mkdir export\html
%GODOT-4.3% --path src/ --export-release "Web" ../export/html/index.html
7z a -tzip export/html.zip ./export/html/*
