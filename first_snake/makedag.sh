#!/bin/bash
echo "Making the DAG as an svg"
snakemake --dag | dot -Tsvg > dag.svg
