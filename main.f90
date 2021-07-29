#include <petsc/finclude/petscmat.h>
#include "petsc/finclude/petscviewer.h"
#include "petsc/finclude/petscsys.h"
#include "petsc/finclude/petscis.h"

program main
    use petscmat
    !use petscviewer
    ! use mpi
    use petscsys
    use petscis
    implicit none
    PetscInt ierr
    Mat matadj
    MatPartitioning part
    type(tIs) is,isg, rows
    PetscInt :: i0(6) = (/0, 2, 4, 7, 10, 12/)
    PetscInt :: j0(12) = (/3,4, 4,5, 3,4,5, 1,2,4, 3,5/)
    PetscInt :: i1(2) = (/0, 3/)
    PetscInt :: j1(3) = (/0,2, 4/)

    integer rank, size

    !!!
    call petscInitialize(PETSC_NULL_CHARACTER, ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD,rank,ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD,size,ierr)
    if(size /= 2) then
        print*,"2 procs !"
    end if

    if(rank == 0) then
        call MatCreateMPIAdj(MPI_COMM_WORLD,5,6,i0,j0,PETSC_NULL_INTEGER,Matadj, ierr)
    elseif (rank == 1) then
        call MatCreateMPIAdj(MPI_COMM_WORLD,1,6,i1,j1,PETSC_NULL_INTEGER,Matadj, ierr)
    endif

    call PetscViewerPushFormat(PETSC_VIEWER_STDOUT_WORLD,PETSC_VIEWER_ASCII_COMMON, ierr)
    CHKERRA(ierr)
    call MatView(Matadj,PETSC_VIEWER_STDOUT_WORLD,ierr)

    call MatPartitioningCreate(MPI_COMM_WORLD,part, ierr)
    call MatPartitioningSetAdjacency(part , Matadj, ierr)
    call MatPartitioningSetFromOptions(part, ierr)
    call ISCreate(MPI_COMM_WORLD,is,ierr)
    call MatPartitioningApply(part,is, ierr)
    call MatPartitioningDestroy(part, ierr)
    call MatDestroy(Matadj, ierr)
    call ISCreate(MPI_COMM_WORLD,isg,ierr)
    call ISPartitioningToNumbering(is,isg,ierr)
    call ISCreate(MPI_COMM_WORLD,rows,ierr)

    call IsView(is, PETSC_VIEWER_STDOUT_WORLD, ierr)
    call ISBuildTwoSided(is,PETSC_NULL_IS, rows, ierr)
    CHKERRA(ierr)
    call IsView(rows, PETSC_VIEWER_STDOUT_WORLD, ierr)

    call petscFinalize(ierr)
end program
