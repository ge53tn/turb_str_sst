#!/bin/sh

cd 00_simpleFoam

blockMesh > log.blockMesh 2>&1

surfaceFeatureExtract > log.surfaceFeatureExtract 2>&1

decomposePar > log.decomposePar 2>&1  # Move it here, before snappyHexMesh

mpirun -np 8 snappyHexMesh -overwrite -parallel > log.snappyHexMesh 2>&1  # Run in parallel

rm -rf 0

rm log.*

cp -rf 0_orig 0

mpirun -np 8 simpleFoam -parallel > log.simpleFoam 2>&1

reconstructPar > log.reconstructPar 2>&1

pyFoamCopyLastToFirst.py . . > log.pyFoamCopyLastToFirst

pyFoamClearCase.py . --processors-remove --keep-postprocessing > log.pyFoamClearCase
