# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.18)

project(openjpeg_ffi_library VERSION 0.0.1 LANGUAGES C)

# Include Flutter's CMake macros and dependencies

set(open_jpeg /home/ubuntu/Projects/openjpeg_ffi/src/android/openjpeg-build/openjpeg-install-${ANDROID_ABI}/lib/openjpeg-2.5)
set(OpenJPEG_DIR ${open_jpeg})
find_package(OpenJPEG REQUIRED HINTS ${open_jpeg})
# include_directories(${OPENJPEG_INCLUDE_DIRS})

add_library(OpenJpeg INTERFACE)
add_dependencies(OpenJpeg ${open_jpeg})
set_property(TARGET OpenJpeg PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${open_jpeg}/include/openjpeg-2.5")
set_property(TARGET OpenJpeg PROPERTY INTERFACE_LINK_DIRECTORIES "${open_jpeg}/lib/")
set_property(TARGET OpenJpeg PROPERTY INTERFACE_LINK_LIBRARIES openjp2)


add_library(openjpeg_ffi SHARED
  "openjpeg_ffi.c"
)

set_target_properties(openjpeg_ffi PROPERTIES
  PUBLIC_HEADER openjpeg_ffi.h
  OUTPUT_NAME "openjpeg_ffi"
)

target_link_libraries(openjpeg_ffi PUBLIC OpenJpeg)
target_compile_definitions(openjpeg_ffi PUBLIC DART_SHARED_LIB)
