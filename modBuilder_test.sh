#!/bin/bash

INCLUDE="*.xml *.lua *.dds src/vehicles/specialization/*.lua src/utils/*.lua src/*.lua translations/*.xml"
ZIP_FILENAME="FS22_FrontBackLiftControl.zip"

zip -r  $ZIP_FILENAME $INCLUDE

mv $ZIP_FILENAME ../mod_folder/