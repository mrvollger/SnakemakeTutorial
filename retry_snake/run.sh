#!/bin/bash

NUM_OF_JOBS=5
snakemake -p -j  $NUM_OF_JOBS --restart-times 5 -s retry.smk --drmaa " {params.cluster_flags} " --drmaa-log-dir retry_log



