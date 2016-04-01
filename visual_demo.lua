#!/usr/bin/env qlua
require('torch')
require('image')
torch.setdefaulttensortype('torch.FloatTensor')
local gSLICr = require('gSLICr')

local input = (arg[1] and image.load(arg[1])) or image.lena()
input = input:mul(255):byte()
local output = input:clone():zero()

gSLICr.init({x = input:size(3),
             y = input:size(2),
             coh_weight = 8,
             no_segs = 512,
             spixel_size = 32,
             seg_method = 1,  -- 0: use no_segs,  1: use spixel_size
            })
gSLICr.feed(input)
gSLICr.process()
gSLICr.retrieve(output)

image.display(output)
