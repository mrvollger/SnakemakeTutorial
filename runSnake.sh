#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
module purge
. /etc/profile.d/modules.sh
module load modules modules-init modules-gs/prod
module load python/3-anaconda
# install snakemake locally if not already there
# you only need to do this once per user
if [ ! -f $HOME/.local/bin/snakemake ]; then
	echo "Snakemake not found, installing"
	pip install --user snakemake
fi

# add the install localtion of snakeamke to your path
PATH=$PATH:$HOME/.local/bin/


#
# snakemake paramenters
#
snakefile=$DIR/snake.py
jobNum=50
waitTime=60 # this really needs to be 60 on our cluster :(
retry=1 # numer of times to retry the pipeline if it failes
# I allow a retry becuase sometimes even the really long waittime is not enough,
# and the files are actaully there

#
# QSUB parameters, these are only the defualts, they can be changed with params.sge_opts
# Allow snakemake to make directories, I think it slows things down when I done with "waitTime"
#
logDir=logs
mkdir -p $logDir
E=$logDir'/snakejob_{rule}_{wildcards}_e'
O=$logDir'/snakejob_{rule}_{wildcards}_o'
ram=4G
defaultCores=1

#
# run snakemake
#
snakemake -p \
        -s $snakefile \
        --drmaa " -P eichlerlab \
                -q eichler-short.q \
                -l h_rt=24:00:00  \
                -l mfree=$ram \
                -V -cwd -e $E -o $O \
                {params.cluster} \
                -S /bin/bash" \
        --jobs $jobNum \
        --latency-wait $waitTime \
        --restart-times $retry  \
        $1 $2 # just a way to pass aditional arguments to snakemake, like --unlock
