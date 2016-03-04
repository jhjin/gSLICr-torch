require('torch')
local ffi = require('ffi')

ffi.cdef[[
void gSLICr_init(int x, int y, int no_segs, int spixel_size,
                 int coh_weight, int no_iters, int color_space,
                 int seg_method, bool do_enforce_connectivity);
void gSLICr_feed(uint8_t *input);
void gSLICr_process();
void gSLICr_retrieve(uint8_t *output);
]]

local gSLICr = {
   C = ffi.load(package.searchpath('libgSLICr', package.cpath)),
}

local COLOR_SPACE = {
   CIELAB = 0,
   XYZ = 1,
   RGB = 2,
}

local SEG_METHOD = {
   GIVEN_NUM = 0,
   GIVEN_SIZE = 1,
}


function gSLICr.init(arg)
   local arg = arg or {}
   local x = arg.x or 640
   local y = arg.y or 480
   local no_segs = arg.no_segs or 2000
   local spixel_size = arg.spixel_size or 16
   local coh_weight = arg.coh_weight or 0.6
   local no_iters = arg.no_iters or 5
   local color_space = arg.color_space or COLOR_SPACE.XYZ
   local seg_method = arg.seg_method or SEG_METHOD.GIVEN_SIZE
   local do_enforce_connectivity = arg.do_enforce_connectivity or true

   gSLICr.C['gSLICr_init'](
      x, y, no_segs, spixel_size, coh_weight, no_iters,
      color_space, seg_method, do_enforce_connectivity
   )
end


function gSLICr.feed(input)
   gSLICr.C['gSLICr_feed'](torch.data(input))
end

function gSLICr.process()
   gSLICr.C['gSLICr_process']()
end

function gSLICr.retrieve(output)
   gSLICr.C['gSLICr_retrieve'](torch.data(output))
end

return gSLICr
