#include "openjpeg_ffi.h"
#include <stdint.h>
#include <stdlib.h>

FFI_PLUGIN_EXPORT int opj_plugin_decode(uint8_t *data, size_t dataLength,
                                        uint8_t **outputData, int *width,
                                        int *height) {

  opj_dparameters_t parameters;
  opj_set_default_decoder_parameters(&parameters);
  opj_codec_t *codec = opj_create_decompress(OPJ_CODEC_J2K);
  opj_set_info_handler(codec, NULL, NULL);
  opj_set_warning_handler(codec, NULL, NULL);
  opj_set_error_handler(codec, NULL, NULL);

  // Initialize a memory stream
  opj_stream_t *stream = opj_stream_create(dataLength, OPJ_TRUE);

  // Set the stream to use your JPEG2000 data
  opj_stream_set_user_data(stream, data, NULL);
  opj_stream_set_user_data_length(stream, dataLength);
  opj_stream_set_read_function(stream, (opj_stream_read_fn)fread);

  // Setup decoding parameters

  // Decode the image
  opj_image_t *image;
  int result = opj_decode(codec, stream, image);

  // Check for errors
  if (!image) {
    opj_stream_destroy(stream);
    opj_destroy_codec(codec);
    return -1; // Decoding error
  }

  // Get image information
  *width = image->x1;
  *height = image->y1;

  // Assuming 8-bit output, you may need to adjust this
  *outputData =
      (uint8_t *)malloc(*width * *height * 3); // Adjust for your image format

  // Copy decoded image data (adjust format if needed)
  for (int comp = 0; comp < image->numcomps; ++comp) {
    for (int y = 0; y < *height; ++y) {
      for (int x = 0; x < *width; ++x) {
        // Copy pixel data (adjust format if needed)
        (*outputData)[(y * *width + x) * 3 + comp] =
            image->comps[comp].data[y * image->comps[comp].w + x];
      }
    }
  }

  // Clean up
  opj_stream_destroy(stream);
  opj_image_destroy(image);
  opj_destroy_codec(codec);
  return result;
};
