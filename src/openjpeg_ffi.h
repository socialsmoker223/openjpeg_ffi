#include <openjpeg-2.5/openjpeg.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT int opj_plugin_decode(uint8_t* data, size_t dataLength, uint8_t** outputData, int* width, int* height);
