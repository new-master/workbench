#!/bin/bash

export TAG=afl4-driller2
export MEMORY_REQUEST=5Gi
export MEMORY_LIMIT=8Gi
export CPU_REQUEST=5000m
export CPU_LIMIT=6000m
export TIMEOUT=28800

curl https://raw.githubusercontent.com/new-master/cgc-bin/master/lists/all_adv.txt | parallel -j100 -k '
NAME=$($WORKBENCH_DIR/scripts/kubesanitize '$TAG'-{});
$WORKBENCH_DIR/scripts/make_pod -l $NAME " \
	wget https://github.com/new-master/cgc-bin/tree/master/adv_patch/{} -O /home/angr/{}; \
	chmod 755 /home/angr/{}; \
	/home/angr/.virtualenvs/angr/bin/shellphuzz /home/angr/{} \
		-t '$TIMEOUT' -C \
		-c4 -d4 \
		-T /shared/tarballs/$NAME-{}.tar.gz \
"
'
