#! /bin/bash
BATCH_NNODES=$(flux resource list -n -o {nnodes})
BATCH_NCORES=$(flux resource list -n -o {ncores})
export NAME="$1"_"$2"

module load $1 $2
mkdir $FTC_DIRECTORY/$NAME
cp -r $MPI_TESTS_DIRECTORY/* $FTC_DIRECTORY/$NAME 
cd $FTC_DIRECTORY/$NAME
echo "Running with $1 compiler and $2 MPI"
for test in $TESTS; do
    mpicc -o $test "$test".c
done
for test in $TESTS; do
    flux run -N $BATCH_NNODES -n $BATCH_NCORES ./"$test"
done
rm -rf $FTC_DIRECTORY/$NAME
