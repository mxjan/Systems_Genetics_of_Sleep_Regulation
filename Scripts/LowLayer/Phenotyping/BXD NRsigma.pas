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
  DIRf,OUTf1,OUTf2         : text;
  EEGf                     : file of epoch;
  spec4                    : epoch;
  strID                    : string[10];
  mID                      : string[11];
  fln                      : string[5];
  str,numStr,m,numM,t,
  so,room,rec,worm,nID     : integer;

  tr                       : single;
  vs                       : array[1..21600] of char;
  ps                       : array[1..21600] of single;
  hz,day,j,i               : integer;
  win                      : array[1..75] of char;
  n                        : array[1..75] of integer;
  sig                      : array[1..75] of single;
  maxS,srf,maxTr,p1r,p2r,
  dif,remO                 : single;
  maxT,p1,p2               : integer;

PROCEDURE READ_spec;
VAR
  local : array[1..75] of single;
  rpow  : single;
  nc    : integer;
BEGIN
  nc:=0; rpow:=0; FOR j:=1 TO 75 DO local[j]:=-1.0;

  FOR j:=1 TO 45 DO
  BEGIN
    IF win[j]='n' THEN
    BEGIN
      local[j]:=ps[t-75+j];
      IF j<31 THEN BEGIN inc(nc); rpow:=rpow+local[j]; END;
    END;
  END;
  FOR j:=46 TO 75 DO IF win[j]='r' THEN local[j]:=ps[t-75+j];

  IF nc>7 THEN
  BEGIN
    rpow:=rpow/nc;
    FOR j:=1 TO 75 DO
    BEGIN
      IF local[j]>0 THEN
      BEGIN
        sig[j]:=local[j]*100/rpow+sig[j];
        inc(n[j]);
      END;
    END;
  END;
END;

PROCEDURE MOVE_window;
VAR
  nc3,rc3 : integer;
BEGIN
  t:=74;
  WHILE t<=21600 DO
  BEGIN
    inc(t);
    FOR j:=1 TO 75 DO
    BEGIN
      i:=t-75+j;
      win[j]:=vs[i];
    END;

    nc3:=0; FOR j:=38 TO 45 DO IF win[j] in ['n','2','5'] THEN inc(nc3);
    rc3:=0; FOR j:=46 TO 48 DO IF win[j] in ['r','3','6'] THEN inc(rc3);

    IF (nc3=8) AND (rc3=3) THEN
    BEGIN
      READ_spec;
      t:=t+3;
    END;
  END;
END;

PROCEDURE READ_state;
VAR
  sigma : single;
BEGIN
  seek(EEGf,(day-1)*21600);
  FOR t:=1 TO 21600 DO
  BEGIN
    read(EEGf,spec4);
    vs[t]:=spec4.state;
    IF spec4.state in ['n','r'] THEN
    BEGIN
      sigma:=0; FOR hz:=44 TO 62 DO sigma:=sigma+spec4.bin[hz]; sigma:=sigma*1000000/19;
      ps[t]:=sigma;
    END
    ELSE ps[t]:=-1.0;
  END;
END;

PROCEDURE Reject;
BEGIN
  maxS:=-1.0;
  srf:=-1.0;
  maxTr:=-1.0;
  p1r:=-1.0;
  p2r:=-1.0;
  dif:=-1.0;
  remO:=-1.0;
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf1,'D:\BXD Sinergia\phenotypes\BXD_NRsigma1.out'); rewrite(OUTf1);
  assign(OUTf2,'D:\BXD Sinergia\phenotypes\BXD_NRsigma2.out'); rewrite(OUTf2);
  writeln(OUTf1,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'maxS':12,'srf':12,'maxTr':12,'p1r':12,'p2r':12,'dif':12,'rem0':12);
  writeln(OUTf2,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'tim':12,'sigma':12,'n':12);

  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm);
      writeln(nID:4,fln:8,m:4);
      assign(EEGf,'D:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);
      FOR j:=1 TO 75 DO BEGIN n[j]:=0; sig[j]:=0; END;
      FOR day:=1 TO 4 DO
      BEGIN
        READ_state;
        MOVE_window;
      END;
      FOR j:=1 TO 75 DO sig[j]:=sig[j]/n[j];

      remO:=sig[46];
      maxS:=0; FOR j:=1 TO 75 DO IF sig[j]>maxS THEN BEGIN maxS:=sig[j]; maxT:=j; END;
      maxTr:=(maxT-45.5)*4;
      j:=maxT; REPEAT dec(j); UNTIL sig[j]<104; p1:=j;
      p1r:=(p1+1)-((sig[p1+1]-104.0)/(sig[p1+1]-sig[p1])); p1r:=(p1r-45.5)*4;
      j:=maxT; REPEAT inc(j); UNTIL sig[j]<100; p2:=j;
      p2r:=(p2-1)+((sig[p2-1]-100.0)/(sig[p2-1]-sig[p2])); p2r:=(p2r-45.5)*4;
      dif:=p2r-p1r;
      srf:=0; FOR j:=p1 TO (p2-1) DO srf:=srf+(sig[j]-100);

      write(OUTf1,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
      IF (nID=61) AND (m=1) THEN reject;
      IF (nID=61) AND (m=2) THEN reject;
      IF (nID=80) AND (m=3) THEN reject;
      IF (nID=75) AND (m=4) THEN reject;
      writeln(OUTf1,maxS:12:3,srf:12:3,maxTr:12:3,p1r:12:3,p2r:12:3,dif:12:3,remO:12:3);

      FOR j:=1 TO 75 DO
      BEGIN
        tr:=j; tr:=(tr-45.5)/15;
        writeln(OUTf2,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5,tr:12:3,sig[j]:12:4,n[j]:12);
      END;
      close(EEGf);
    END; {mouse}
  END; {strain}

  close(OUTf1);
  close(OUTf2);
  close(DIRf);
END.