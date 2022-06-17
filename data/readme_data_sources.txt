GSynth requires the following models' data. Please, download the files from the following sources and store the data files in this directory "data".


Data files sources:


- Gravity Field Model
Gravity models are provided by the International Centre for Global Earth Models (ICGEM) through the following link
http://icgem.gfz-potsdam.de/tom_longtime

Download the *gfc file of a global gravity field model e.g. EIGEN-6C4, EGM2008



- Ocean Tides model:
The source code makes use of the ocean tides model in the form of Geopotential spherical harmonic coefficients.
The FES2014b model is available from CNES/GRGS

https://grace.obs-mip.fr/dealiasing_and_tides/ocean-tides/

http://gravitegrace.get.obs-mip.fr/geofluid/fes2014b.v1.Cnm-Snm_Om1+Om2C20_with_S1_wave.POT_format.txt



- Planetary and Lunar ephemeris (DE series) by Jet Propulsion Laboratory JPL/NASA 

The JPL DE ephemerides series are provided through ftp:
https://ssd.jpl.nasa.gov/ftp/eph/planets/ascii/

Download the two required files (ascii format) e.g. ascp2000.423 and header.423
https://ssd.jpl.nasa.gov/ftp/eph/planets/ascii/de423/



- Earth Orientation Parameters (EOP)

The EOP solution series provided by the Earth Orientation Center of the International Earth Rotation and Reference Systems Service (IERS) are being used for the Earth Orientation modelling.
https://hpiers.obspm.fr/eop-pc/index.php

Download the data file refer to the EOP C04 solution from the following link:

https://hpiers.obspm.fr/iers/eop/eopc04/eopc04_IAU2000.62-now

