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
  t,i                      : integer;
  vs                       : array[0..43200] of byte;


PROCEDURE READ_STATE;
BEGIN
  FOR t:=1 TO 43200 DO
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
  tw,lw,nlw,c           : integer;
  twr,lwr,nlwr          : single;
BEGIN
  tw:=0; lw:=0; nlw:=0; c:=1;
  FOR t:=1 TO 43200 DO
  BEGIN
    IF vs[t]=1       THEN inc(tw);
    IF vs[t]=vs[t-1] THEN inc(c)
    ELSE
    BEGIN
      IF (vs[t-1]=1) AND (c>255) THEN
      BEGIN
        lw:=lw+c;
        inc(nlw);
      END;
      c:=1;
    END;
  END;
  twr:=tw; lwr:=lw; lwr:=lwr*100/twr;
  twr:=twr/900;
  nlwr:=nlw; nlwr:=nlwr/twr;
  writeln(OUTf,lwr:12:3,nlwr:12:4);
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_longW.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'longW%':12,'longW#':12);
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

      READ_STATE;
      close(EEGf);
      DET_DIS;

      writeln(strID:10,fln:6);
    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.