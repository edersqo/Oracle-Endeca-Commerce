#!/bin/sh

# Start Guided Search Endeca Services

/etc/init.d/endeca_platform start
/etc/init.d/endeca_tools start
/etc/init.d/endeca_cas start
