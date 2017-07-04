macro(build_open_blas install_prefix staging_prefix build_parallel)

  set_property(DIRECTORY PROPERTY EP_STEP_TARGETS configure build test)

  if(NOT CMAKE_Fortran_COMPILER)
    message("Fortran compiler not found! OpenBLAS will not work as expected!")
  endif(NOT CMAKE_Fortran_COMPILER)
  
  #SET(BLAS_PARALLEL "NO_AFFINITY=1 USE_THREAD=0 USE_OPENMP=0")

  if(${build_parallel})
    SET(BLAS_PARALLEL "NO_AFFINITY=1 USE_OPENMP=1")
  else(${build_parallel})
    SET(BLAS_PARALLEL "NO_AFFINITY=1 USE_THREAD=0 USE_OPENMP=0")
  endif(${build_parallel})
  
  ExternalProject_Add(OpenBLAS
        URL "http://github.com/xianyi/OpenBLAS/archive/v0.2.19.tar.gz"
        URL_MD5 "28c998054fd377279741c6f0b9ea7941"
        SOURCE_DIR OpenBLAS
        BUILD_IN_SOURCE 1
        #BINARY_DIR OpenBLAS-build
        INSTALL_DIR       "${CMAKE_BINARY_DIR}/external"
        BUILD_COMMAND      $(MAKE) PREFIX=${install_prefix} ${BLAS_PARALLEL} CC=${CMAKE_C_COMPILER} FC=${CMAKE_Fortran_COMPILER} MAKE_NB_JOBS=1
        CONFIGURE_COMMAND  $(MAKE) PREFIX=${install_prefix} ${BLAS_PARALLEL} CC=${CMAKE_C_COMPILER} FC=${CMAKE_Fortran_COMPILER} MAKE_NB_JOBS=1
        INSTALL_COMMAND    $(MAKE) DESTDIR=${CMAKE_BINARY_DIR}/external install PREFIX=${install_prefix}
      )
  
  # a hack to find full path to gfortran library
  
  #find_library( GFORTRAN_LIBRARY NAMES gfortran )
  SET(OpenBLAS_INCLUDE_DIRS ${staging_prefix}/${install_prefix}/include )
  SET(OpenBLAS_LIBRARY      ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libopenblas.so  ) # ${GFORTRAN_LIBRARY}
  SET(OpenBLAS_DIR          ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/cmake/openblas )
  SET(OpenBLAS_FOUND ON)

endmacro(build_open_blas)
  