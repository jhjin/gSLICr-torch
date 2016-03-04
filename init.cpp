#include <stdint.h>
#include "gSLICr/gSLICr_Lib/gSLICr.h"

gSLICr::engines::core_engine* gSLICr_engine;
gSLICr::UChar4Image* in_img;
gSLICr::UChar4Image* out_img;


extern "C"
void gSLICr_init(int x, int y, int no_segs, int spixel_size,
                 int coh_weight, int no_iters, int color_space,
                 int seg_method, bool do_enforce_connectivity)
{
   gSLICr::objects::settings my_settings;
   my_settings.img_size.x = x;
   my_settings.img_size.y = y;
   my_settings.no_segs = no_segs;
   my_settings.spixel_size = spixel_size;
   my_settings.coh_weight = coh_weight;
   my_settings.no_iters = no_iters;
   my_settings.color_space = static_cast<gSLICr::COLOR_SPACE>(color_space);
   my_settings.seg_method = static_cast<gSLICr::SEG_METHOD>(seg_method);
   my_settings.do_enforce_connectivity = do_enforce_connectivity;

   // instantiate a core_engine
   if (gSLICr_engine)
      delete gSLICr_engine;
   gSLICr_engine = new gSLICr::engines::core_engine(my_settings);

   // gSLICr takes gSLICr::UChar4Image as input and out put
   if (in_img)
      delete in_img;
   in_img = new gSLICr::UChar4Image(my_settings.img_size, true, true);

   if (out_img)
      delete out_img;
   out_img = new gSLICr::UChar4Image(my_settings.img_size, true, true);
}

extern "C"
void gSLICr_feed(uint8_t *input)
{
   gSLICr::Vector4u* in_img_ptr = in_img->GetData(MEMORYDEVICE_CPU);

   int stride = in_img->noDims.x*in_img->noDims.y;
   for (int i = 0; i < stride; i++) {
      in_img_ptr[i].b = input[i+stride*0];
      in_img_ptr[i].g = input[i+stride*1];
      in_img_ptr[i].r = input[i+stride*2];
   }
}

extern "C"
void gSLICr_process()
{
   gSLICr_engine->Process_Frame(in_img);
}

extern "C"
void gSLICr_retrieve(uint8_t *output)
{
   gSLICr_engine->Draw_Segmentation_Result(out_img);

   const gSLICr::Vector4u* out_img_ptr = out_img->GetData(MEMORYDEVICE_CPU);

   int stride = out_img->noDims.x*out_img->noDims.y;
   for (int i = 0; i < stride; i++) {
      output[i+stride*0] = out_img_ptr[i].b;
      output[i+stride*1] = out_img_ptr[i].g;
      output[i+stride*2] = out_img_ptr[i].r;
   }
}
