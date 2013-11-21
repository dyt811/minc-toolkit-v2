macro(build_C3D C3D_location install_prefix staging_prefix)
  if(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else()
    set(CMAKE_GEN "${CMAKE_GENERATOR}")
  endif()
  
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    SET(C3D_CXX_COMPILER "${CMAKE_CXX_COMPILER}" CACHE FILEPATH "C++ Compiler for C3D")
    SET(C3D_C_COMPILER "${CMAKE_C_COMPILER}" CACHE FILEPATH "C Compiler for C3D")
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}
      -DCMAKE_C_COMPILER:FILEPATH=${C3D_C_COMPILER}
      -DCMAKE_CXX_COMPILER:FILEPATH=${C3D_CXX_COMPILER}
    )
  endif()

  ExternalProject_Add(C3D
    URL "${C3D_location}"
    UPDATE_COMMAND ""
    SOURCE_DIR C3D
    BINARY_DIR C3D-build
    LIST_SEPARATOR :::  
    CMAKE_GENERATOR ${CMAKE_GEN}
    CMAKE_ARGS
        -DFFTW3F_FOUND:BOOL=${FFTW3F_FOUND}
        -DFFTW3F_INCLUDE_DIR:PATH=${FFTW3F_INCLUDE_DIR}
        -DFFTW3F_LIBRARY:PATH=${FFTW3F_LIBRARY}
        -DFFTW_LIB:FILEPATH=${FFTW3F_LIBRARY}
        -DUSE_MINC4ITK:BOOL=YES
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DLIBMINC_DIR:PATH=${CMAKE_BINARY_DIR}/libminc
        -DMINC4ITK_DIR:PATH=${CMAKE_BINARY_DIR}/minc4itk
        -DITK_DIR:PATH=${ITK_DIR}
        -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
        -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
        -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
        -DCMAKE_EXE_LINKER_FLAGS=${CMAKE_EXE_LINKER_FLAGS}
        -DCMAKE_MODULE_LINKER_FLAGS=${CMAKE_MODULE_LINKER_FLAGS}
        -DCMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}
        ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
    INSTALL_COMMAND make install DESTDIR=${staging_prefix}
    INSTALL_DIR ${staging_prefix}/${install_prefix}
  )
endmacro(build_C3D)
