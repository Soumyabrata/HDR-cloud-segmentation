# High-Dynamic-Range Imaging for Cloud Segmentation

With the spirit of reproducible research, this repository contains all the codes required to produce the results in the manuscript: 
> S. Dev, F. M. Savoy, Y. H. Lee and S. Winkler, High-Dynamic-Range Imaging for Cloud Segmentation, *Atmospheric Measurement Techniques (AMT)*, 2018.

Please cite the above paper if you intend to use whole/part of the code. This code is only for academic and research purposes.

## Code Organization
The codes are written in python and MATLAB.

### Dataset
We release the associated dataset of this manuscript to the research community. This will be helpful for public benchmarking and subsequent research. Please visit this [link](http://vintage.winklerbros.net/index.html) for more details.

### Core functionality
* `something.m` Information.

The codes related to HDR imaging are contained in the folder `./HDRimaging`. These codes are adapted from:
> Debevec, Paul E., and Jitendra Malik. "Recovering high dynamic range radiance maps from photographs." In Proceedings of the 24th annual conference on Computer graphics and interactive techniques, pp. 369-378. ACM Press/Addison-Wesley Publishing Co., 1997.

The codes related to graph cut are contained in the folder `./GraphCut`. Please cite the following papers, in case you use this graph cut module.
> Efficient Approximate Energy Minimization via Graph Cuts, Yuri Boykov, Olga Veksler, Ramin Zabih, IEEE transactions on PAMI, vol. 20, no. 12, p. 1222-1239, November 2001.

> What Energy Functions can be Minimized via Graph Cuts?, Vladimir Kolmogorov and Ramin Zabih, IEEE Transactions on Pattern Analysis and Machine Intelligence, (PAMI), vol. 26, no. 2, February 2004, pp. 147-159.

> An Experimental Comparison of Min-Cut/Max-Flow Algorithms for Energy Minimization in Vision, Yuri Boykov and Vladimir Kolmogorov, In IEEE Transactions on Pattern Analysis and Machine Intelligence, (PAMI), vol. 26, no. 9, September 2004, pp. 1124-1137.

> Matlab Wrapper for Graph Cut, Shai Bagon, in www.wisdom.weizmann.ac.il/~bagon, December 2006.

### Reproducibility 

Please run the following to generate all the results and figures in the paper.
* `main.m` Performs something

In addition to all the related codes, we have also shared the generated results. These files are contained in the folder `./results`.
