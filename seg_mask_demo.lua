require('torch')
torch.setdefaulttensortype('torch.FloatTensor')
require('sys')
require('image')
local gSLICr = require('gSLICr')


if arg[1] and not arg[2] then
   print('Must specify both an input and output file')
   print(' ... or for Lena demo, exclude all arguments')
   os.exit()
end

local input = (arg[1] and image.load(arg[1])) or image.lena()
local output_file = arg[2] or 'lena_spixels.dat'

input = input:mul(255):byte()
local output = torch.FloatTensor(input:size(2), input:size(3))


gSLICr.init({x = input:size(3),
             y = input:size(2),
             coh_weight = 8,
             no_segs = 512,
             spixel_size = 32,
             seg_method = 1,  -- 0: use no_segs,  1: use spixel_size
            })

sys.tic()
gSLICr.feed(input)
gSLICr.process()
gSLICr.get_seg(output)
local seg_time = sys.toc()

print(torch.max(output) .. ' superpixels in ' .. seg_time .. ' seconds')

print('Saving serialized segmentation mask to ' .. output_file)
torch.save(output_file, output)
