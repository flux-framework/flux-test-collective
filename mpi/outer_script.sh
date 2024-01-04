#!/bin/bash

CORONA_COMPILERS="
gcc
clang
intel-classic
"

CORONA_MPIS="
mvapich2
"

export TESTS="hello
abort
version
"

IS_CORONA=$(echo $HOSTNAME | grep corona)
## REQUIRES: $MPI_TESTS_DIRECTORY $HOSTNAME
## start a flux instance over all nodes in allocation (2)
if ! test -z $IS_CORONA; then
    for mpi in $CORONA_MPIS; do
        for compiler in $CORONA_COMPILERS; do
            flux batch -N2 -n4 --flags=waitable -o output.stdout.type=kvs $MPI_TESTS_DIRECTORY/inner_script.sh $mpi $compiler
        done
    done
    flux job wait --all
    for id in $(flux jobs -f completed -no {id}); do
        printf "\033[31mjob $id completed:\033[0m\n"
        flux job attach $id
    done
fi
