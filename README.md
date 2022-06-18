# ![GSynth_logo5_reduced](https://user-images.githubusercontent.com/102968112/174288312-2b039dc2-f4f6-483d-b603-d8f591f42541.png)


## GSynth: Software for gravity field functionals and Earth tides effects


GSynth is a software for computing gravity field functionals (gravity anomalies, geoid heights) and Earth tides effects considering solid Earth tides and Ocean tides. 
GSynth has been developed by Thomas since 2013. The initial version included two main modules, GRAVsynth and GRAVtide, that have been now merged into one code package.

GRAVsynth: Spherical harmonic synthesis of gravity field models for computing gravity anomalies and geoid heights 

GRAVtide: Solid Earth and Ocean Tides effects modelling 

The software is being used in gravity data analysis and tides modelling.

# 

### Guide: Instructions for configuration and data requirements

GSynth can be executed through applying the following steps:
1. Download the models' data required by executing the script file `gsynth_data_models.m` stored in the folder `'../scripts/'`

```
cd scripts/
gsynth_data_models
```

2. Set the configuration file `config_gsynth.in` stored in the folder `'../config/'`

3. Set the input data points file stored in the folder `'../config/'`. Default file for the coputations data points is the `points_gsynth.in` that is being set withing the configuration file. 

4. Execute the main script of the software `gsynth_main.m` in the folder `'../main/'` 

```
cd main/
gsynth_main
```

5. The restuls are written in an output file saved in the folder `'../results/'`

# 

### References:

Papanikolaou T., Papadopoulos N.  (2015). High-frequency analysis of Earth gravity field models based on terrestrial gravity and GPS/levelling data: A case study in Greece, Journal of Geodetic Science, Vol. 5, No. 1, pp. 67-79 doi: 10.1515/jogs-2015-0008 .

Papanikolaou T. (2013). GRAVsynth and GRAVtide software' User guide, Dept. of Gravimetry, HMGS, Greece.
