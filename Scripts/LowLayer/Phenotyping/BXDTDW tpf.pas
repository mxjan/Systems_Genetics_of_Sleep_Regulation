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
  DIRf,OUTf            : text;
  EEGf                 : file of epoch;
  strID                : string[10];
  mID                  : string[11];
  fln                  : string[5];
  str,numStr,m,numM,ld,
  t,so,vs,day,room,rec,worm,nID,
  tdw,peakf,start      : integer;
  spec4                : epoch;
  ratio                : single;
  tpf                  : array[1..4] of single;


PROCEDURE calcper;
VAR
  hz                : integer;
  peakp,theta,total : single;
BEGIN
  peakp:=0;
  FOR hz:=14 TO 60 DO                                                        {determine peak frequency between 3.5 and 15 Hz}
  BEGIN
    IF spec4.bin[hz]>peakp THEN
    BEGIN
      peakp:=spec4.bin[hz];
      peakf:=hz;
    END;
  END;

  IF (peakf>26) AND (peakf<48) THEN                                          {peak frequency has to be >6.5 Hz and <12 Hz}
  BEGIN
    theta:=0; FOR hz:=(peakf-4) TO (peakf+4) DO theta:=theta+spec4.bin[hz];  {theta band 2.25 Hz broad adjusted according to peak frequency}
    total:=0; FOR hz:=14 TO 180 DO total:=total+spec4.bin[hz];               {total power 3.5 - 45 Hz}
    ratio:=theta/total;
  END
  ELSE ratio:=0;
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_TDW tpf.out'); rewrite(OUTf);
   writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'TPF_Db':12,'TPF_Dr1':12,'TPF_Dr2':12,'TPF_r1d':12,'TPF_r2d':12,'TPF_SD':12);

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
      start:=10799;
      FOR day:=1 TO 4 DO
      BEGIN
        tpf[day]:=0.0; tdw:=0;
        seek(EEGf,start+(day-1)*21600);  {tpf in each D-period}
        FOR t:=1 TO 10800 DO
        BEGIN
          read(EEGf,spec4);
          IF spec4.state='w' THEN
          BEGIN
            calcper;
            IF ratio>0.228 THEN
            BEGIN
              inc(tdw);
              tpf[day]:=tpf[day]+peakf;
            END;
          END;
        END;
        tpf[day]:=tpf[day]/tdw;
        tpf[day]:=tpf[day]/4;
      END;

      tpf[2]:=(tpf[2]+tpf[1])/2;         {baseline average}
      FOR day:=2 TO 4 DO write(OUTf,tpf[day]:12:3);
      FOR day:=3 TO 4 DO write(OUTf,tpf[day]-tpf[2]:12:3);

      tpf[1]:=0.0; tdw:=0; {tpf in SD}
      seek(EEGf,2*21600);
      FOR t:=1 TO 5400 DO
      BEGIN
        read(EEGf,spec4);
        IF spec4.state='w' THEN
        BEGIN
          calcper;
          IF ratio>0.228 THEN
          BEGIN
            inc(tdw);
            tpf[1]:=tpf[1]+peakf;
          END;
        END;
      END;
      tpf[1]:=tpf[1]/tdw;
      tpf[1]:=tpf[1]/4;
      writeln(OUTf,tpf[1]:12:3);

      close(EEGf);
      writeln(strID:10,fln:6);
    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.