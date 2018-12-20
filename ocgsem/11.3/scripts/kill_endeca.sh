#!/bin/sh

# Kills Endeca ITL runing processes. (Platform Services, ToolsAndFrameworks, CAS)
ps -ef | grep endeca | sed 's/\s+/ /g' | cut -d ' ' -f5 | xargs kill -9