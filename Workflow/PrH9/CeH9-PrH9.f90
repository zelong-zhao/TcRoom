PROGRAM readi
IMPLICIT NONE
!nkpt= 'k points =  427' from scf.out
!nbnd= 'nbnd 120' form FullGF.dat
!133 * 120
INTEGER,PARAMETER :: unit_read = 100, unit_write = 200
INTEGER, PARAMETER :: nkpt = 427, nbnd = 120, nrot=24, nbnd_write = 120
CHARACTER(len=10) :: junkch1, junkch2, junkch3,junkch4, junkch5
REAL :: k1,k2,k3, junkreal
INTEGER :: ik, ibnd, irep, junkint, nb
REAL :: energies(nbnd,nkpt), kpoints(3,nkpt), energies_Evg(nbnd,nkpt), kpoints_cart(3,nkpt), kpointrotcart(3), occupation_Evg(nbnd,nkpt)
REAL :: bg(3,3)
REAL :: sumrule

!     reciprocal axes: (cart. coord. in units 2 pi/alat)
!          b(1) = (  1.027969  0.146675  0.447704 )
!          b(2) = ( -0.173044  1.042629  0.072955 )
!          b(3) = (  0.096003 -0.055944  1.091554 )

bg(:,1) = (/ 1.000000, 0.577350, 0.000000 /)
bg(:,2) = (/ 0.000000, 1.154701, 0.000000 /)
bg(:,3) = (/ 0.000000, 0.000000, 0.667990 /)

OPEN(unit=unit_read,file='FullGF.dat')
DO ik=1,nkpt
  !
  DO ibnd=1,nbnd
    READ(unit_read,*) kpoints_cart(1,ik),kpoints_cart(2,ik),kpoints_cart(3,ik),junkint,occupation_Evg(ibnd,ik),energies_Evg(ibnd,ik)
  ENDDO
  kpoints_cart(:,ik) = kpoints_cart(1,ik) * bg(:,1) + kpoints_cart(2,ik) * bg(:,2) + kpoints_cart(3,ik) * bg(:,3)
ENDDO
CLOSE(unit_read)

OPEN(unit=unit_write,file='eigenenergies.dat')
WRITE(unit_write,*) nbnd_write, nkpt, nrot

DO ik=1,nkpt
  DO nb=1,nrot
    CALL Rotatek(kpoints_cart(:,ik),kpointrotcart(:),nb)
    DO irep = 1,1!2
      DO ibnd=1,nbnd_write
        WRITE(unit_write,*) kpointrotcart(:), nb, ibnd+nbnd*(irep-1), energies(ibnd,ik), energies_Evg(ibnd,ik)
!        WRITE(unit_write,*) kpointrotcart(:), nb, ibnd+nbnd_write*(irep-1), occupation_Evg(ibnd,ik), energies_Evg(ibnd,ik)+20.9705!+8.824118
      ENDDO
    ENDDO
  ENDDO
ENDDO
CLOSE(unit_write)

CONTAINS


SUBROUTINE Rotatek(k_in,k_out,rot_id)
IMPLICIT NONE
REAL, INTENT(IN) :: k_in(3)
REAL, INTENT(OUT) :: k_out(3)
INTEGER, INTENT(IN) :: rot_id
REAL, DIMENSION(3,3,24) :: O_h

  O_h(:,:,1) = reshape((/ 1d0,0d0,0d0,0d0,1d0,0d0,0d0,0d0,1d0/),shape(O_h(:,:,1)))
  O_h(:,:,2) = reshape((/ -1d0,0d0,0d0,0d0,-1d0,0d0,0d0,0d0,1d0/),shape(O_h(:,:,1)))
  O_h(:,:,3) = reshape((/ -1d0,0d0,0d0,0d0,1d0,0d0,0d0,0d0,-1d0/),shape(O_h(:,:,1)))
  O_h(:,:,4) = reshape((/ 1d0,0d0,0d0,0d0,-1d0,0d0,0d0,0d0,-1d0/),shape(O_h(:,:,1)))
  O_h(:,:,5) = reshape((/ 0.5d0,-0.8660254d0,0d0,0.8660254d0,0.5d0,0d0,0d0,0d0,1d0/),shape(O_h(:,:,1)))
  O_h(:,:,6) = reshape((/ 0.5d0,0.8660254d0,0d0,-0.8660254d0,0.5d0,0d0,0d0,0d0,1d0/),shape(O_h(:,:,1)))
  O_h(:,:,7) = reshape((/ -0.5d0,-0.8660254d0,0d0,0.8660254d0,-0.5d0,0d0,0d0,0d0,1d0/),shape(O_h(:,:,1)))
  O_h(:,:,8) = reshape((/ -0.5d0,0.8660254d0,0d0,-0.8660254d0,-0.5d0,0d0,0d0,0d0,1d0/),shape(O_h(:,:,1)))
  O_h(:,:,9) = reshape((/ 0.5d0,-0.8660254d0,0d0,-0.8660254d0,-0.5d0,0d0,0d0,0d0,-1d0/),shape(O_h(:,:,1)))
  O_h(:,:,10) = reshape((/ 0.5d0,0.8660254d0,0d0,0.8660254d0,-0.5d0,0d0,0d0,0d0,-1d0/),shape(O_h(:,:,1)))
  O_h(:,:,11) = reshape((/ -0.5d0,-0.8660254d0,0d0,-0.8660254d0,0.5d0,0d0,0d0,0d0,-1d0/),shape(O_h(:,:,1)))
  O_h(:,:,12) = reshape((/ -0.5d0,0.8660254d0,0d0,0.8660254d0,0.5d0,0d0,0d0,0d0,-1d0/),shape(O_h(:,:,1)))
  O_h(:,:,13) = -O_h(:,:,1)
  O_h(:,:,14) = -O_h(:,:,2)
  O_h(:,:,15) = -O_h(:,:,3)
  O_h(:,:,16) = -O_h(:,:,4)
  O_h(:,:,17) = -O_h(:,:,5)
  O_h(:,:,18) = -O_h(:,:,6)
  O_h(:,:,19) = -O_h(:,:,7)
  O_h(:,:,20) = -O_h(:,:,8)
  O_h(:,:,21) = -O_h(:,:,9)
  O_h(:,:,22) = -O_h(:,:,10)
  O_h(:,:,23) = -O_h(:,:,11)
  O_h(:,:,24) = -O_h(:,:,12)

  k_out(:)=MATMUL(O_h(:,:,rot_id),k_in(:))

END SUBROUTINE

END PROGRAM readi
