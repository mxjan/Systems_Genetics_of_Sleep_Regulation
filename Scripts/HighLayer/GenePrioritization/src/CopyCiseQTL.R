CopyciseQTL<-function(OutputName,Tissu,Condition){
	if (Tissu=="C" & Condition == "NSD"){system(paste("cp",FileciseQTLCortexNSD,paste(OutputName,".ciseQTL.txt",sep='')))}
	if (Tissu=="L" & Condition == "NSD"){system(paste("cp",FileciseQTLLiverNSD,paste(OutputName,".ciseQTL.txt",sep='')))}
	if (Tissu=="C" & Condition == "SD"){system(paste("cp",FileciseQTLCortexSD,paste(OutputName,".ciseQTL.txt",sep='')))}
	if (Tissu=="L" & Condition == "SD"){system(paste("cp",FileciseQTLLiverSD,paste(OutputName,".ciseQTL.txt",sep='')))}
	return(paste(OutputName,".ciseQTL.txt",sep=''))
}

