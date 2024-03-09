#!/usr/bin/env  bash

google-chrome --profile-directory=Default \
	--enable-features=WaylandWindowDecorations \
	--ozone-platform-hint=auto \
	--app-id=mejfjggmbnocnfibbibmoogocnjbcjnk \
	$*

# google-chrome --profile-directory=Default --app-id=mejfjggmbnocnfibbibmoogocnjbcjnk --force-device-scale-factor=1 $*
