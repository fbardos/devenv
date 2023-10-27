#!/bin/zsh

# --- Switch to playground environment ---
echo '##################################'
echo '##### SWITCHED TO PLAYGROUND #####'
echo '##################################'

source ~/miniconda3/etc/profile.d/conda.sh
conda activate playground
cd ~/code/playground/
python --version

# Change Airflow ENVs
#export AIRFLOW_HOME='~/Documents/ckan_qa/airflow'
#export AIRFLOW__CORE__DAGS_FOLDER='~/Documents/ckan_qa/airflow/dags'
#airflow info

