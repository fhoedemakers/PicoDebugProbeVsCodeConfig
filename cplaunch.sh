:
if [ ! -d ".vscode" ] ; then  
	echo "No .vscode subdir" 
	exit 1
fi
echo "1 debug 2040"
echo "2 debug 2350"
read -p "choice " choice
if [ "$choice" = "1" ] ; then
	cp ~/scripts/vs/launch.json .vscode/launch.json
	echo "Created .vscode/launch.json for RP2040"
elif [ "$choice" = "2" ] ; then
	cp ~/scripts/vs/launch2350.json .vscode/launch.json
	echo "Created .vscode/launch.json for RP2350"
else
	echo "Bad choice"
	exit 1
fi
