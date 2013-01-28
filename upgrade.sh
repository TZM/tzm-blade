printf '\033[0;34m%s\033[0m\n' "Upgrading ZMGC"
if git pull origin master
then
	printf '\033[0;32m%s\033[0m\n'  '       ___           ___           ___           ___     '
	printf '\033[0;32m%s\033[0m\n'  '      /__/\         /  /\         /  /\         /  /\    '
	printf '\033[0;32m%s\033[0m\n'  '      \  \:\       /  /::|       /  /::\       /  /::\   '
	printf '\033[0;32m%s\033[0m\n'  '       \  \:\     /  /:|:|      /  /:/\:\     /  /:/\:\  '
	printf '\033[0;32m%s\033[0m\n'  '        \  \:\   /  /:/|:|__   /  /:/  \:\   /  /:/  \:\ '
	printf '\033[0;32m%s\033[0m\n'  '   ______\__\:\ /__/:/_|::::\ /__/:/_\_ \:\ /__/:/ \  \:\'
	printf '\033[0;32m%s\033[0m\n'  '  \  \::::::::/ \__\/  /~~/:/ \  \:\__/\_\/ \  \:\  \__\/'
	printf '\033[0;32m%s\033[0m\n'  '   \  \:\~~~~~        /  /:/   \  \:\ \:\    \  \:\      '
	printf '\033[0;32m%s\033[0m\n'  '    \  \:\           /  /:/     \  \:\/:/     \  \:\     '
	printf '\033[0;32m%s\033[0m\n'  '     \  \:\         /__/:/       \  \::/       \  \:\    '
	printf '\033[0;32m%s\033[0m\n'  '      \__\/         \__\/         \__\/         \__\/    '
	printf '\033[0;34m%s\033[0m\n' 'Hooray! ZMGC has been updated and/or is at the current version.'
	printf '\033[0;34m%s\033[1m%s\033[0m\n' 'To keep up on the latest, be sure to follow https://github.com/TZM/tzm-blade'
else
	printf '\033[0;31m%s\033[0m\n' 'There was an error updating. Try again later?'
fi