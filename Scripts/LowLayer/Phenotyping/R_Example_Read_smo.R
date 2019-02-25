# Example to read a smo file using R

# smo files are available at figshare (see documentation or related publication)
binfile = file("1D203.smo", "rb")

states<-c() # vector for mouse states (Wake = 'w',NREM = 'n', REM = 'r')
powspecm<-matrix(ncol=401,nrow=86400) # Matrix for power spectra from 0Hz to 100Hz with a 0.25Hz frequency
miscm<-matrix(ncol=3,nrow=86400) # matrix that will contain EEG variance, EMG variance and temperature

for (i in seq(1,86400)){
  state<-readChar(binfile,1)
  states<-c(states,state)
  powspec<-readBin(binfile,what=single(),n=401,size = 4)
  misc<-readBin(binfile,what=single(),n=3,size=4)
  powspecm[i,]<-powspec
  miscm[i,]<-misc
}

head(powspecm)
