PROGRAM NameXYZ;

USES
  strings;
TYPE
  epoch = RECORD
            state          : char;
            bin            : array[0..400] of single;
            EEGv,EMGv,temp : single;
          END;
VAR
  DIRf,OUTf                : text;
  EEGf                     : file of epoch;
  strID                    : string[10];
  mID                      : string[11];
  fln                      : string[5];
  str,numStr,m,numM,so,
  room,rec,worm,nID        : integer;
  spec4                    : epoch;

  t,start,stop,day,i       : integer;
  vs                       : array[0..3600] of byte;
  swr,snr                  : array[1..3,1..2] of single;


PROCEDURE READ_STATE;
BEGIN
  FOR t:=1 TO stop DO
  BEGIN
    read(EEGf,spec4);
    CASE spec4.state OF
      'w','1','4' : vs[t]:=1;
      'n','2','5' : vs[t]:=2;
      'r','3','6' : vs[t]:=3;
    END;
  END;
  vs[0]:=vs[1];
END;

PROCEDURE DET_DIS;
VAR
  tn,sw,sn,c               : integer;
  lr                       : real;
BEGIN
  tn:=0; sw:=0; sn:=0; c:=1;
  FOR t:=1 TO stop DO
  BEGIN
    IF vs[t]=2       THEN inc(tn);
    IF vs[t]=vs[t-1] THEN inc(c)
    ELSE
    BEGIN
      IF (vs[t-1]=1) AND (c<=4) THEN inc(sw);
      IF (vs[t-1]=2) THEN IF c<=15 THEN inc(sn);
      c:=1;
    END;
  END;

  lr:=tn; lr:=lr/900;
  swr[day,i]:=sw; swr[day,i]:=swr[day,i]/lr;
  snr[day,i]:=sn; snr[day,i]:=snr[day,i]/lr;
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_nBAbslrec.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'nBAbsl':12,'nBArec':12,'nBAref':12,'nBAbd':12,'nBArd':12,
                                                                               'nBSbsl':12,'nBSrec':12,'nBSref':12,'nBSbd':12,'nBSrd':12);
  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm);
      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
      assign(EEGf,'D:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);

      FOR day:=1 TO 2 DO
      BEGIN
        FOR i:=1 TO 2 DO
        BEGIN
          start:=(day-1)*21600+(i-1)*7200;
          seek(EEGf,start);
          IF i=1 THEN stop:=2700 ELSE stop:=3600;
          READ_STATE;
          DET_DIS;
        END;
      END;

      day:=3; i:=1;
      start:=(day-1)*21600+5400;
      seek(EEGf,start);
      stop:=2700;
      READ_STATE;
      DET_DIS;

      close(EEGf);

      FOR i:=1 TO 2 DO
      BEGIN
        swr[2,i]:=(swr[2,i]+swr[1,i])/2;
        snr[2,i]:=(snr[2,i]+snr[1,i])/2;
      END;
      writeln(OUTf,swr[2,1]:12:3,swr[3,1]:12:3,swr[2,2]:12:3,(swr[2,1]-swr[2,2]):12:3,(swr[3,1]-swr[2,2]):12:3,
                   snr[2,1]:12:3,snr[3,1]:12:3,snr[2,2]:12:3,(snr[2,1]-snr[2,2]):12:3,(snr[3,1]-snr[2,2]):12:3);
      writeln(strID:10,fln:6);
    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.