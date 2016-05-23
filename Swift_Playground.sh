

# Get the Alfred query into a Bash variable
query={query}

# If no argument provided, default to:
#  - Desktop
#  - ios
#  - MyPlayground
if [ -z "$query" ]; then
	DESTINATION="/users/$(whoami)/Desktop"
	PLATFORM="ios"
	FILE_NAME="MyPlayground"
else
	# Separate it into an array for better usage
	queries=($query)

	DESTINATION=${queries[0]}
	PLATFORM=${queries[1]}
	"$PLATFORM" | tr '[:upper:]' '[:lower:]' > PLATFORM
	FILE_NAME=${queries[2]}
fi

# Go to the user specified location
cd $DESTINATION

# Initiate the playground as a folder
mkdir $FILE_NAME

# Get inside the playground folder
cd $FILE_NAME

# Create the required playground files
# `playground.xcworkspace` will be automatically created by XCode
# otherwise Xcode crashes
touch Contents.swift
touch contents.xcplayground

# Fill up `Contents.swift`
echo '// Playground - noun: a place where people can play' > Contents.swift
echo '' >> Contents.swift
echo 'import UIKit' >> Contents.swift
echo '' >> Contents.swift
echo 'var str = "Hello, playground"' >> Contents.swift

# Fill up `contents.xcplayground`
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' > contents.xcplayground
echo "<playground version='5.0' target-platform='${PLATFORM}'>" >> contents.xcplayground

# if [ "$PLATFORM" == "ios" ]; then
# 	echo "<playground version='5.0' target-platform='ios'>" >> contents.xcplayground
# elif [ "$PLATFORM" == "osx" ]; then
# 	echo "<playground version='5.0' target-platform='osx'>" >> contents.xcplayground
# elif [ "$PLATFORM" == "tvos" ]; then
# 	echo "<playground version='5.0' target-platform='tvos'>" >> contents.xcplayground
# else
# 	echo "<playground version='5.0' target-platform='unknown'>" >> contents.xcplayground
# 	echo "ERROR: Platform unknown."
# fi

echo "	<timeline fileName='timeline.xctimeline'/>" >> contents.xcplayground
echo "</playground>" >> contents.xcplayground

# Go back and rename the folder as an official Xcode playground file
cd ..
mv $FILE_NAME $FILE_NAME.playground

# Launch Xcode with the created playground file
open -a 'Xcode' $FILE_NAME.playground
