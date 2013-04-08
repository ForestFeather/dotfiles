#!/bin/bash
#################################################################################
# FILE: ~/.screen/temp.sh
# AUTHOR: Collin "Ridayah" O'Connor <ridayah@gmail.com>
# VERSION: 1.0,1
# Simply checks if we have ACPI /proc info, and then outputs whether we have some
# info in long or short format, or N/A if nothing.
#################################################################################

if [ -f /proc/acpi/thermal_zone/THM/temperature ]; then
	if [ $1 == "--short" ]; then
		echo "$(awk '{ printf "%sC", $2}' /proc/acpi/thermal_zone/THM/temperature)"
	else
		echo "Temp: $(awk '{ printf "%sC", $2 }' /proc/acpi/thermal_zone/THM/temperature)"
	fi
else
	if [ $1 == "--short" ]; then
		echo "N/A"
	else
		echo "Temp: N/A"
	fi
fi
