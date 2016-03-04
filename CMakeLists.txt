CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)
CMAKE_POLICY(VERSION 2.8)

SET(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" "${CMAKE_MODULE_PATH}")

FIND_PACKAGE(Torch REQUIRED)
FIND_PACKAGE(CUDA REQUIRED)  
FIND_PACKAGE(OpenCV REQUIRED)

INCLUDE_DIRECTORIES(${CUDA_INCLUDE_DIRS})
INCLUDE_DIRECTORIES(${OpenCV_INCLUDE_DIRS})
ADD_SUBDIRECTORY(gSLICr/ORUtils)

FILE(GLOB luasrc *.lua)
FILE(GLOB src
init.cpp
gSLICr/gSLICr_Lib/engines/gSLICr_core_engine.h
gSLICr/gSLICr_Lib/engines/gSLICr_seg_engine.h
gSLICr/gSLICr_Lib/engines/gSLICr_seg_engine_GPU.h
gSLICr/gSLICr_Lib/engines/gSLICr_seg_engine_shared.h
gSLICr/gSLICr_Lib/engines/gSLICr_core_engine.cpp
gSLICr/gSLICr_Lib/engines/gSLICr_seg_engine.cpp
gSLICr/gSLICr_Lib/engines/gSLICr_seg_engine_GPU.cu
gSLICr/gSLICr_Lib/objects/gSLICr_settings.h
gSLICr/gSLICr_Lib/objects/gSLICr_spixel_info.h
gSLICr/gSLICr_Lib/gSLICr_defines.h
gSLICr/gSLICr_Lib/gSLICr.h
)

LIST(APPEND "-std=c++11 -ftree-vectorize")

CUDA_ADD_LIBRARY(gSLICr MODULE ${src} OPTIONS -gencode arch=compute_30,code=compute_30)
IF(APPLE)
    SET_TARGET_PROPERTIES(gSLICr PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
ENDIF()

### Torch packages supposes libraries prefix is "lib"
SET_TARGET_PROPERTIES(gSLICr PROPERTIES
    PREFIX "lib"
    IMPORT_PREFIX "lib")

INSTALL(TARGETS gSLICr
    RUNTIME DESTINATION "${Torch_INSTALL_LUA_CPATH_SUBDIR}"
    LIBRARY DESTINATION "${Torch_INSTALL_LUA_CPATH_SUBDIR}")

INSTALL(
    FILES
    ${luasrc}
    DESTINATION "${Torch_INSTALL_LUA_PATH_SUBDIR}/gSLICr")
