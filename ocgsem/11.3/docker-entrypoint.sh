#!/bin/sh
set -e

# Starts Guided Search Endeca Services.
sh /home/endeca/bin/endeca_start_services.sh

# Execute bash not allowing the container to exit.
exec /bin/bash