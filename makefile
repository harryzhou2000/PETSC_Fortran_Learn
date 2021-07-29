OptFlag=-g
PetscPath=${PETSC}include
PetscBuildPath=${PETSC}arch_WSL_Build_A/include
Include=-I"${PetscPath}" -I"${PetscBuildPath}"
Module=
Libs=-lpetsc -llapack
FC=mpif90

Flags:=-cpp ${OptFlag} ${Include} ${Module}

all: main.exe

funcs.o: funcs.f90
	${FC} funcs.f90 -c -o funcs.o ${Flags}

main.exe: main.f90 funcs.o
	${FC} main.f90 funcs.o -o main.exe ${Libs} ${Flags}