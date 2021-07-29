module funcs
    implicit none

contains
    subroutine setArray(A)
        integer, allocatable::A(:)
        A(1) = 123123
    end subroutine
end module
