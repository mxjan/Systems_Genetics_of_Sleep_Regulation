#!/usr/bin/python2

import fileinput
import sys
import os

# PreProcess phenotype file, check if continous data or qualitative data.
# Continuous data are transform into quant.out and qualitative data into qual.out
# OT file are over time values, to process them with function-values QTL methods

# File BXDw24bsl.out, no change
# OT: 1.5h interval, waking [min] over 48h baseline
out = open('BXDw24bsl.quant.out','w')
for line in open('BXDw24bsl.out','r').readlines():
	out.write(line)

# File BXDn24bsl.out, no change
# OT: 1.5h interval, NREM [min] over 48h baseline
out = open('BXDn24bsl.quant.out','w')
for line in open('BXDn24bsl.out','r').readlines():
	out.write(line)

# File BXDr24bsl.out, no change
# OT: 1.5h interval, REM [min] over 48h baseline
out = open('BXDr24bsl.quant.out','w')
for line in open('BXDr24bsl.out','r').readlines():
	out.write(line)

# File BXDdel20m.out, no change
# Delta EEG 1st 20min NREM avec SD, [%] of baseline
# Remove nc,ref1,ref2 and t, keep only ref (mean ref at ZT8-12), del, so (sleep onset, time to fall asleep after SD)
out = open('BXDdel20m.quant.out','w')
c = 0
for line in open('BXDdel20m.out','r').readlines():
	ls = line.split()
	del ls[11] # t
	del ls[10] # nc
	del ls[8] # ref1
	del ls[7] # ref2
	line = '\t'.join(ls)+'\r\n'
	out.write(line)

# File BXD1224bsl.out, no change
# Time spend wake, rem, nrem for 12h, LD, 24h [min]
out = open('BXDvs1224bsl.quant.out','w')
for line in open('BXDvs1224bsl.out','r').readlines():
	out.write(line)

# File actwak1224bsl.out, no change
# activity, mouvement over 24h,12h LD intervals
# Remove w24,w12L,w12D
out = open('actwak1224bsl.quant.out','w')
for line in open('actwak1224bsl.out','r').readlines():
	ls = line.split()
	del ls[14] # w12D
	del ls[11] # w12L
	del ls[8] # w24
	line = '\t'.join(ls)+'\r\n'
	out.write(line)

# File BXDvsREC.out, no change
# time [min] wake, rem, nrem during and after SD
# P1 -> SD
# P2+3 -> recover in dark periods only
# P2+3+4 -> 18h recover
# P2+3+4+5 -> 24h recover
# Separated OT and Combined Periods
out = open('BXDvsREC.quant.out','w')
out2 = open('BXDvsREC_Wake.quant_OT.out','w')
out3 = open('BXDvsREC_NREM.quant_OT.out','w')
out4 = open('BXDvsREC_REM.quant_OT.out','w')
for line in open('BXDvsREC.out','r').readlines():
	ls = line.split()
	ls_quant = [ls[0],ls[1],ls[2],ls[3],ls[4],ls[5],ls[6],ls[12],ls[13],ls[14],ls[20],ls[21],ls[22],ls[28],ls[29],ls[30]]
	ls_quant_OT_Wake = [ls[0],ls[1],ls[2],ls[3],ls[4],ls[5],ls[6],ls[7],ls[8],ls[9],ls[10],ls[11]]
	ls_quant_OT_NREM = [ls[0],ls[1],ls[2],ls[3],ls[4],ls[5],ls[6],ls[15],ls[16],ls[17],ls[18],ls[19]]
	ls_quant_OT_REM = [ls[0],ls[1],ls[2],ls[3],ls[4],ls[5],ls[6],ls[23],ls[24],ls[25],ls[26],ls[27]]
	out.write('\t'.join(ls)+'\r\n')
	out2.write('\t'.join(ls_quant_OT_Wake)+'\r\n')
	out3.write('\t'.join(ls_quant_OT_NREM)+'\r\n')
	out4.write('\t'.join(ls_quant_OT_REM)+'\r\n')

# File BXDvsRECdif.out, no change
# Same as above, SD period not take, expressed as diff from baseline
out = open('BXDvsRECdif.quant.out','w')
out2 = open('BXDvsRECdif_Wake.quant_OT.out','w')
out3 = open('BXDvsRECdif_NREM.quant_OT.out','w')
out4 = open('BXDvsRECdif_REM.quant_OT.out','w')
for line in open('BXDvsRECdif.out','r').readlines():
	ls = line.split()
	ls_quant = [ls[0],ls[1],ls[2],ls[3],ls[4],ls[5],ls[6],ls[11],ls[12],ls[13],ls[18],ls[19],ls[20],ls[25],ls[26],ls[27]]
	ls_quant_OT_Wake = [ls[0],ls[1],ls[2],ls[3],ls[4],ls[5],ls[6],ls[7],ls[8],ls[9],ls[10]]
	ls_quant_OT_NREM = [ls[0],ls[1],ls[2],ls[3],ls[4],ls[5],ls[6],ls[14],ls[15],ls[16],ls[17]]
	ls_quant_OT_REM = [ls[0],ls[1],ls[2],ls[3],ls[4],ls[5],ls[6],ls[21],ls[22],ls[23],ls[24]]
	#out.write('\t'.join(ls_quant)+'\r\n')
	out.write('\t'.join(ls)+'\r\n')
	out2.write('\t'.join(ls_quant_OT_Wake)+'\r\n')
	out3.write('\t'.join(ls_quant_OT_NREM)+'\r\n')
	out4.write('\t'.join(ls_quant_OT_REM)+'\r\n')

# File BXDvsRECgain.out, no change
# gain and lost due to SD [min or %]
out = open('BXDvsRECgain.quant.out','w')
for line in open('BXDvsRECgain.out','r').readlines():
	out.write(line)


# File LDDLactwbsl.out, no change
out = open('LDDLactwbsl.quant.out','w')
for line in open('LDDLactwbsl.out','r').readlines():
	out.write(line)


# File LDDLactwbsl.out, NaN introducted for -1 in sleep episode duration (dur-sleep)
# No strain with only -1, keep data as quantitative
# Wake and activity LD
out = open('BXDsleepepisodesSD.quant.out','w')
c = 0
for line in open('BXDsleepepisodesSD.out','r').readlines():
	if c > 0:
		line = line.split()
		try:
			if float(line[-1])<= -1:
				line[-1] = 'NA'
		except:
			pass
		line = '\t'.join(line)+'\r\n'
	out.write(line)
	c += 1


# File BXDseizures.out, NaN introducted for -1 
# Create a qualitative file with mice without (0) with (1) seizures
out = open('BXDseizures.quant.out','w')

# Qual 
data = {}
out2 = open('BXDseizures.qual.out','w')

c = 0
for line in open('BXDseizures.out','r').readlines():
	if c > 0:
		ls = line.split()
		try:
			if float(ls[-1])<= -1:
				ls[-1] = 'NA'
		except:
			pass
		line = '\t'.join(ls)+'\r\n'
		
		if ls[1] not in data:
			data[ls[1]] = 0
		if ls[7] != '0':
			data[ls[1]]+= 1
	c += 1	
	out.write(line)

out2.write('line\tseizures\r\n')
for strain in data:
	if data[strain] == 0:
		out2.write(strain+'\t0\r\n')
	else:
		out2.write(strain+'\t1\r\n')

	


# File BXDspindles.out, NaN introducted for -1 
# Create a qualitative file with mice without (0) with (1) spindles
out = open('BXDspindles.quant.out','w')

# Qual 
data = {}
out2 = open('BXDspindles.qual.out','w')

c = 0
for line in open('BXDspindles.out','r').readlines():
	if c > 0:
		ls = line.split()
		if float(ls[-1]) <= -1:
			ls[-1] = 'NA'
		if float(ls[-3]) <= -1:
			ls[-3] = 'NA'
		if float(ls[-5]) <= -1:
			ls[-5] = 'NA'
		line = '\t'.join(ls)+'\r\n'
		
		if ls[1] not in data:
			data[ls[1]] = {"Wspin":0,"Nspin":0,"Rspin":0}
		if ls[-2] != '0':
			data[ls[1]]["Rspin"]+= 1	
		if ls[-4] != '0':
			data[ls[1]]["Nspin"]+= 1
		if ls[-6] != '0':
			data[ls[1]]["Wspin"]+= 1

	c += 1
	out.write(line)

out2.write('line\tWspin\tNspin\tRspin\r\n')
for strain in data:
	wspin = '0'
	nspin = '0'
	rspin = '0'
	if data[strain]["Wspin"] > 0:
		wspin = '1'
	if data[strain]["Nspin"] > 0:
		nspin = '1'
	if data[strain]["Rspin"] > 0:
		rspin = '1'
	out2.write(strain+'\t'+wspin+'\t'+nspin+'\t'+rspin+'\r\n')




# File BXD_NR-ratio.out, no change
out = open('BXD_NR-ratio.quant.out','w')
for line in open('BXD_NR-ratio.out','r').readlines():
	out.write(line)


# File BXD_TDWh.out, no change
out = open('BXD_TDWh.quant.out','w')
for line in open('BXD_TDWh.out','r').readlines():
	out.write(line)

# File BXD_TDWh.out, no change
out = open('BXD_PS_tpf.quant.out','w')
for line in open('BXD_PS tpf.out','r').readlines():
	out.write(line)

# File BXD_TDW tpf.out, no change
out = open('BXD_TDW_tpf.quant.out','w')
for line in open('BXD_TDW tpf.out','r').readlines():
	out.write(line)

# File BXD_POG.out, no change
out = open('BXD_POG.quant.out','w')
for line in open('BXD_POG.out','r').readlines():
	out.write(line)


# File BXD_INOUT.out, no change
out = open('BXD_INOUT.quant.out','w')
for line in open('BXD_INOUT.out','r').readlines():
	out.write(line)

# File BXD_num_ep_bsl.out, no change
out = open('BXD_num_ep_bsl.quant.out','w')
for line in open('BXD_num_ep_bsl.out','r').readlines():
	out.write(line)


# File BXD_nBA.out, no change
out = open('BXD_nBA.quant.out','w')
for line in open('BXD_nBA.out','r').readlines():
	out.write(line)



# File BXD_nBAbslrec.out, no change
out = open('BXD_nBAbslrec.quant.out','w')
for line in open('BXD_nBAbslrec.out','r').readlines():
	out.write(line)


# File BXDactrec.out, no change
out = open('BXDactrec.quant.out','w')
for line in open('BXDactrec.out','r').readlines():
	out.write(line)


# File BXD_longW.out, no change
out = open('BXD_longW.quant.out','w')
for line in open('BXD_longW.out','r').readlines():
	out.write(line)

# File BXD_EEGref.out, no change
out = open('BXD_EEGref.quant.out','w')
for line in open('BXD_EEGref.out','r').readlines():
	out.write(line)



# File BXD_TPF-P.out, NaN introducted for -1 
# Create a qualitative file, remove qualitative data from original file
out = open('BXD_TPF-P.quant.out','w')
#out2 = open('BXD_TPF-P.qual.out','w')
datap1 = {}
datap2 = {}

c = 0
for line in open('BXD_TPF-P.out','r').readlines():
	if c > 0:
		ls = line.split()
		if float(ls[-1]) <= -1:
			ls[-1] = 'NA'
		if float(ls[-2]) <= -1:
			ls[-2] = 'NA'
		if float(ls[-3]) <= -1:
			ls[-3] = 'NA'

		if ls[1] not in datap1:
			datap1[ls[1]] = 0
			datap2[ls[1]] = 0
		datap1[ls[1]]+=int(ls[12])
		datap2[ls[1]]+=int(ls[17])
		
		del ls[12]
		del ls[16]
		line = '\t'.join(ls)+'\r\n'
	else:
		ls = line.split()
		del ls[12]
		del ls[16]
		line = '\t'.join(ls)+'\r\n'
	c += 1
	out.write(line)

#out2.write('line\tpresent1\tpresent2\r\n')
for strain in data:
	if datap1[strain]> 0:
		p1 = '1'
	else:
		p1 = '0'
	if datap2[strain]>0:
		p2 = '1'
	else:
		p2 = '0'
	#out2.write(strain+'\t'+p1+'\t'+p2+'\r\n')




# File BXD_NREMS EEG bands.out, no change
out = open('BXD_NREMS_EEG_bands.quant.out','w')
for line in open('BXD_NREMS EEG bands.out','r').readlines():
	ls = line.split()
	c = 0
	for i in ls:
		try:
			if float(i) <= -1:
				ls[c] = 'NA'
		except:
			pass
		c += 1
	line = '\t'.join(ls)+'\r\n'
	out.write(line)


# File BXD_REM EEG bands.out, no change
out = open('BXD_REM_EEG_bands.quant.out','w')
for line in open('BXD_REM EEG bands.out','r').readlines():
	ls = line.split()
	c = 0
	for i in ls:
		try:
			if float(i) <= -1:
				ls[c] = 'NA'
		except:
			pass
		c += 1
	line = '\t'.join(ls)+'\r\n'
	out.write(line)

# File BXD_REM EEG bands.out, no change
out = open('BXD_Wak_EEG_bands.quant.out','w')
for line in open('BXD_Wak EEG bands.out','r').readlines():
	ls = line.split()
	c = 0
	for i in ls:
		try:
			if float(i) <= -1:
				ls[c] = 'NA'
		except:
			pass
		c += 1
	line = '\t'.join(ls)+'\r\n'
	out.write(line)


# File BXD WNR spec bands.out, no change
out = open('BXD_WNR_spec_bands.quant.out','w')
for line in open('BXD WNR spec bands.out','r').readlines():
	ls = line.split()
	c = 0
	for i in ls:
		try:
			if float(i) <= -1:
				ls[c] = 'NA'
		except:
			pass
		c += 1
	line = '\t'.join(ls)+'\r\n'
	out.write(line)



# File BXD WNR spec bands.out, no change
out = open('BXD_NREMSspecSD.quant.out','w')
for line in open('BXD_NREMSspecSD.out','r').readlines():
	ls = line.split()
	c = 0
	for i in ls:
		try:
			if float(i) <= -9:
				ls[c] = 'NA'
		except:
			pass
		c += 1
	line = '\t'.join(ls)+'\r\n'
	out.write(line)


# File BXDdeldyn2.out, no change
out = open('BXDdeldyn2.quant.out','w')
for line in open('BXDdeldyn2.out','r').readlines():
	out.write(line)

out = open('BXD_NRsigma1.quant.out','w')
for line in open('BXD_NRsigma1.out','r').readlines():
	ls = line.split()
	c = 0
	for i in ls:
		try:
			if float(i) <= -999.000:
				ls[c] = 'NA'
		except:
			pass
		c += 1
	line = '\t'.join(ls)+'\r\n'
	out.write(line)












