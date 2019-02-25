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
  spec4                : epoch;
  strID                : string[10];
  mID                  : string[11];
  fln                  : string[5];
  str,numStr,m,numM,t,
  so,room,rec,worm,nID : integer;

  wc,nc,rc             : integer;
  wcr,ncr,rcr,tot      : single;
  vs                   : array[0..43201] of char;


PROCEDURE CALC_RATIO;
VAR
  n : integer;
BEGIN
  wcr:=0; ncr:=0; rcr:=0; n:=0;
  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      inc(n);
      readln(DIRf,mID,fln,so,room,rec,worm);
      assign(EEGf,'D:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);
      wc:=0; nc:=0; rc:=0;
      FOR t:=1 TO 43200 DO
      BEGIN
        read(EEGf,spec4);
        CASE spec4.state OF
          'w','1','4' : inc(wc);
          'n','2','5' : inc(nc);
          'r','3','6' : inc(rc);
        END;
      END;
      wcr:=wcr+wc/2; ncr:=ncr+nc/2; rcr:=rcr+rc/2;
    END;
  END;
  wcr:=wcr/n; ncr:=ncr/n; rcr:=rcr/n;
  tot:=wcr+ncr+rcr;
  wcr:=wcr/tot; ncr:=ncr/tot; rcr:=rcr/tot;
  write(wcr:12:4,ncr:12:4,rcr:12:5); readln;
  reset(DIRf);
END;

PROCEDURE READ_state;
BEGIN
  FOR t:=1 TO 43200 DO
  BEGIN
    read(EEGf,spec4);
    vs[t]:=spec4.state
  END;
  vs[0]:=vs[1]; vs[43201]:=vs[43200];
  reset(EEGf);
END;

PROCEDURE CALC_ref;
VAR
  hz                       : integer;
  refw,refn,refr,local,ref : single;
BEGIN
  refw:=0; refn:=0; refr:=0;
  wc:=0; nc:=0; rc:=0;
  FOR t:=1 TO 43200 DO
  BEGIN
    read(EEGf,spec4);
    IF (vs[t]=vs[t-1]) AND (vs[t]=vs[t+1]) THEN
    BEGIN
      IF vs[t] IN ['w','n','r'] THEN
      BEGIN
        local:=0; FOR hz:=3 TO 180 DO local:=local+spec4.bin[hz];
        IF local>0 THEN
        BEGIN
          CASE vs[t] OF
            'w' : BEGIN IF local*1000000<4000 THEN BEGIN inc(wc); refw:=refw+local; END; END;
            'n' : BEGIN inc(nc); refn:=refn+local; END;
            'r' : BEGIN inc(rc); refr:=refr+local; END;
          END;
        END;
      END;
    END;
  END;
  close(EEGf);
  refw:=refw*1000000/wc; refn:=refn*1000000/nc; refr:=refr*1000000/rc;
  ref:=refw*wcr+refn*ncr+refr*rcr;
  writeln(OUTf,ref:12:3,refw:12:3,refn:12:3,refr:12:3,refn*100/refw:12:3,refr*100/refw:12:3,refn*100/refr:12:3);
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_ref.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'refall':12,'refw':12,'refn':12,'refr':12,'n%w':12,'r%w':12,'n%r':12);

{ CALC_ratio;}
  wcr:=0.4988; ncr:=0.4407; rcr:=0.0604;

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
      READ_state;
      CALC_ref;
      writeln(strID:10,fln:6);
    END; {mouse}
  END; {strain}

  close(DIRf);
  close(OUTf);
END.