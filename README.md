# gSLICr-Torch wrapper

A Torch wrapper for gSLICr super-pixel algorithm
https://github.com/carlren/gSLICr .


## Install

```bash
git clone http://github.com/jhjin/gSLICr-torch.git --recursive
cd gSLICr-torch
luarocks make
```


## Demos

```bash
qlua visual_demo.lua input.jpg
th seg_mask_demo.lua input.jpg output.dat
```
