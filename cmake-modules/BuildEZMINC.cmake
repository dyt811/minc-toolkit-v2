macro(build_EZMINC install_prefix staging_prefix libminc_dir bicpl_dir itk_dir)
  if(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else()
    set(CMAKE_GEN "${CMAKE_GENERATOR}")
  endif()
  
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    SET(ITK_CXX_COMPILER "${CMAKE_CXX_COMPILER}" CACHE FILEPATH "C++ Compiler for ITK")
    SET(ITK_C_COMPILER "${CMAKE_C_COMPILER}" CACHE FILEPATH "C Compiler for ITK")
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}
      -DCMAKE_C_COMPILER:FILEPATH=${ITK_C_COMPILER}
      -DCMAKE_CXX_COMPILER:FILEPATH=${ITK_CXX_COMPILER}
    )
  endif()

  ExternalProject_Add(EZMINC
    #URL "${CMAKE_SOURCE_DIR}/EZminc"
    #UPDATE_COMMAND ""
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/EZminc
    BINARY_DIR EZMINC-build
    LIST_SEPARATOR :::  
    CMAKE_GENERATOR ${CMAKE_GEN}
    CMAKE_ARGS
        -DFFTW3F_FOUND:BOOL=${FFTW3F_FOUND}
        -DFFTW3F_INCLUDE_DIR:PATH=${FFTW3F_INCLUDE_DIR}
        -DFFTW3F_LIBRARY:PATH=${FFTW3F_LIBRARY}
        -DFFTW_LIB:FILEPATH=${FFTW3F_LIBRARY}
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DLIBMINC_DIR:PATH=${libminc_dir}
        -DITK_DIR:PATH=${itk_dir}
        -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
        -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
        -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
        -DEZMINC_BUILD_MINCNLM:BOOL=ON
        -DEZMINC_BUILD_DISTORTION_CORRECTION:BOOL=ON
        -DEZMINC_BUILD_MRFSEG:BOOL=ON
        -DEZMINC_BUILD_DD:BOOL=OFF
        -DEZMINC_BUILD_TOOLS:BOOL=ON
        -DCMAKE_EXE_LINKER_FLAGS=${CMAKE_EXE_LINKER_FLAGS}
        -DCMAKE_MODULE_LINKER_FLAGS=${CMAKE_MODULE_LINKER_FLAGS}
        -DCMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}
        #-DBICPL_DIR:PATH=${bicpl_dir}
        -DGSL_CBLAS_LIBRARY:FILEPATH=${GSL_CBLAS_LIBRARY}
        -DGSL_INCLUDE_DIR:PATH=${GSL_INCLUDE_DIR}
        -DGSL_LIBRARY:FILEPATH=${GSL_LIBRARY}
        ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
    INSTALL_COMMAND make install DESTDIR=${staging_prefix}
    INSTALL_DIR ${staging_prefix}/${install_prefix}
  )
endmacro(build_EZMINC)