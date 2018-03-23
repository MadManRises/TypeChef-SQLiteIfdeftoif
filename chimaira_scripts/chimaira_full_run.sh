cd ~/TypeChef-SQLiteIfdeftoif/
sbatch chimaira_scripts/chimaira_performance_allyes.sh $1
sbatch chimaira_scripts/chimaira_performance_featurewise.sh $1
sbatch chimaira_scripts/chimaira_performance_featurewise_variant.sh $1
sbatch chimaira_scripts/chimaira_performance_pairwise.sh $1
sbatch chimaira_scripts/chimaira_performance_pairwise_variant.sh $1
sbatch chimaira_scripts/chimaira_performance_random.sh $1
sbatch chimaira_scripts/chimaira_performance_random_variant.sh $1
