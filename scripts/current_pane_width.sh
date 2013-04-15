#!/bin/bash
tmux list-panes -t "Session" | grep \(active\) | awk -F'[\[x\]]' '{print $2}'
