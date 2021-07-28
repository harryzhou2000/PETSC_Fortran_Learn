OptFlag=-g
PetscPath=${PETSC}include
PetscBuildPath=${PETSC}arch_WSL_Build_A/include
Include=-I"${PetscPath}" -I"${PetscBuildPath}"
Module=
Libs=-lpetsc -llapack
FC=mpif90

Flags:=-cpp ${OptFlag} ${Include} ${Module}

all: main.exe

main.exe: main.f90
	${FC} main.f90 -o main.exe ${Libs} ${Flags}