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
  DIRf,REFf,OUTf           : text;
  EEGf                     : file of epoch;
  spec4                    : epoch;
  strID                    : string[10];
  mID                      : string[11];
  fln                      : string[5];
  str,numStr,m,numM,t,
  so,room,rec,worm,nID     : integer;

  info                     : string[50];
  ref                      : single;
  vs                       : array[0..43201] of char;
  lbi,ubi,hz,st            : integer;
  lb,ub                    : single;
  local,hzr                : single;
  c                        : array[1..3] of integer;
  spec                     : array[1..3,3..360] of single;


PROCEDURE ipol1;
BEGIN
  ubi:=trunc(ub*4);
  FOR st:=1 TO 3 DO spec[st,ubi]:=(spec[st,ubi-1]+spec[st,ubi+1])/2;
END;

PROCEDURE ipol2;
VAR
  nbi  : integer;
  dif : single;
BEGIN
  lbi:=trunc(lb*4);
  ubi:=trunc(ub*4);
  nbi:=(ubi)-lbi+2;
  FOR st:=1 TO 3 DO
  BEGIN
    dif:=(spec[st,(ubi+1)]-spec[st,(lbi-1)])/nbi;
    FOR hz:=lbi TO ubi DO spec[st,hz]:=dif*(hz-(lbi-1))+spec[st,lbi-1];
  END;
END;

PROCEDURE READ_state;
BEGIN
  reset(EEGf);
  FOR t:=1 TO 43200 DO
  BEGIN
    read(EEGf,spec4);
    vs[t]:=spec4.state
  END;
  vs[0]:=vs[1]; vs[43201]:=vs[43200];
END;

PROCEDURE remove_art;
VAR
  prev : single;
BEGIN
  {remove 75 - 77 Hz in all mice}
  lb:=75.00; ub:=77.00; ipol2;

  {mouse for which EEG is useless}
  if (nID=92) and (m=1) then FOR hz:=3 TO 360 DO FOR st:=1 TO 3 DO spec[st,hz]:=-1.00;

  {animals for which Waking EEG is too artefacted}
  if (nID=2)  and (m=1) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=44) and (m=3) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=45) and (m=6) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=46) and (m=1) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=53) and (m=3) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=60) and (m=3) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=68) and (m=5) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=88) and (m=4) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=92) and (m=1) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=95) and (m=5) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;
  if (nID=96) and (m=2) then FOR hz:=3 TO 360 DO spec[1,hz]:=-1.00;

  {remove specific frequency bins with artefacts in all 3 states (notably 8, 16, 32 Hz)}
  if (nID=1)  and (m=3) then begin lb:=8.00; ub:=8.25; ipol2; lb:=15.75; ub:=16.25; ipol2; lb:=31.75; ub:=32.25; ipol2; lb:=43.75; ub:=44.00; ipol2;
                                   lb:=55.75; ub:=56.25; ipol2; lb:=71.25; ub:=72.25; ipol2; end;
  if (nID=3)  and (m=2) then begin lb:=38.0; ub:=38.25; ipol2; end;
  if (nID=3)  and (m=5) then begin ub:=8.00; ipol1; lb:=15.75; ub:=16.25;; ipol2; lb:=31.75; ub:=32.25; ipol2; end;
  if (nID=4)  and (m=9) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; ub:=44.50; ipol1; ub:=56.00; ipol1; ub:=64.00; ipol1; ub:=72.00; ipol1; end;
  if (nID=28) and (m=4) then begin lb:=44.50; ub:=45.25; ipol2; end;
  if (nID=31) and (m=2) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=42) and (m=4) then begin ub:=8.00; ipol1; ub:=32.00; ipol1; lb:=41.75; ub:=42.25; ipol2; lb:=57.75; ub:=58.25; ipol2; end;
  if (nID=42) and (m=5) then begin lb:=44.00; ub:=46.00; ipol2; end;
  if (nID=43) and (m=1) then begin ub:=15.25; ipol1; lb:=31.75; ub:=32.25; ipol2; lb:=42.00; ub:=42.50; ipol2; lb:=57.50; ub:=57.75; ipol2;
                                   lb:=69.00; ub:=69.50; ipol2; end;
  if (nID=43) and (m=3) then begin ub:=8.00; ipol1; lb:=31.75; ub:=32.25; ipol2; ub:=45.00; ipol1; lb:=63.75; ub:=64.25; ipol2; ub:=72.00; ipol1; end;
  if (nID=43) and (m=5) then begin ub:=8.00; ipol1; lb:=15.75; ub:=16.25; ipol2; lb:=31.75; ub:=32.25; ipol2; lb:=44.25; ub:=45.00; ipol2;
                                   lb:=63.75; ub:=64.25; ipol2; lb:=71.75; ub:=72.25; ipol2; end;
  if (nID=46) and (m=3) then begin ub:=16.00; ipol1; lb:=31.75; ub:=32.25; ipol2; end;
  if (nID=47) and (m=4) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=48) and (m=5) then begin lb:=42.25; ub:=42.50; ipol2; end;
  if (nID=48) and (m=6) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; lb:=31.75; ub:=32.25; ipol2; lb:=42.00; ub:=42.50; ipol2; end;
  if (nID=49) and (m=2) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=49) and (m=3) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=49) and (m=4) then begin lb:=53.25; ub:=53.75; ipol2; lb:=61.50; ub:=61.75; ipol2; end;
  if (nID=53) and (m=1) then begin lb:=63.75; ub:=64.00; ipol2; end;
  if (nID=59) and (m=4) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=61) and (m=4) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=61) and (m=5) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; lb:=23.75; ub:=24.25; ipol2; ub:=32.00; ipol1; lb:=63.75; ub:=64.25; ipol2; end;
  if (nID=61) and (m=6) then begin ub:=8.00; ipol1; ub:=24.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=63) and (m=2) then begin lb:=37.75; ub:=38.25; ipol2; end;
  if (nID=63) and (m=4) then begin lb:=37.75; ub:=38.25; ipol2; end;
  if (nID=65) and (m=4) then begin ub:=8.00; ipol1; lb:=15.75; ub:=16.25; ipol2; lb:=31.75; ub:=32.25; ipol2; lb:=55.75; ub:=56.25; ipol2;
                                   lb:=71.75; ub:=72.25; ipol2; end;
  if (nID=65) and (m=5) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=75) and (m=5) then begin lb:=37.75; ub:=38.25; ipol2; end;
  if (nID=75) and (m=6) then begin lb:=37.75; ub:=38.25; ipol2; end;
  if (nID=79) and (m=1) then begin ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=80) and (m=3) then begin lb:=61.25; ub:=61.75; ipol2; end;
  if (nID=80) and (m=5) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; lb:=23.50; ub:=24.00; ipol2; end;
  if (nID=80) and (m=6) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=85) and (m=6) then begin ub:=8.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=87) and (m=3) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=87) and (m=5) then begin lb:=44.25; ub:=44.75; ipol2; end;
  if (nID=92) and (m=4) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; end;
  if (nID=92) and (m=5) then begin lb:=43.50; ub:=45.50; ipol2; end;
  if (nID=92) and (m=7) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; lb:=44.50; ub:=44.75; ipol2; end;
  if (nID=93) and (m=2) then begin lb:=37.75; ub:=38.25; ipol2; end;
  if (nID=93) and (m=3) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; ub:=38.00; ipol1; end;
  if (nID=93) and (m=5) then begin lb:=37.75; ub:=38.25; ipol2; end;
  if (nID=95) and (m=7) then begin ub:=8.00; ipol1; ub:=16.00; ipol1; ub:=32.00; ipol1; lb:=55.75; ub:=56.25; ipol2;
                                   lb:=63.75; ub:=64.25; ipol2; lb:=71.75; ub:=72.25; ipol2; end;

  {remove 45 - 55 Hz in all mice}
  lb:=45.25; ub:=54.75; ipol2;

  {automatically remove artefacts >80 Hz}
  hz:=320; prev:=spec[1,hz];
  REPEAT
    inc(hz);
    IF (spec[1,hz]/prev)>1.01 THEN
    BEGIN
      lbi:=hz; lb:=hz; lb:=lb/4;
      REPEAT inc(hz); UNTIL (spec[1,hz]<prev) OR (hz>=360);
      ubi:=hz; ub:=hz; ub:=ub/4;
    { write('shit':6,ubi:4);}
      IF hz<360 THEN ipol2
      ELSE FOR hz:=lbi TO ubi DO FOR st:=1 TO 3 DO spec[st,hz]:=-1.00;
    END
    ELSE prev:=spec[1,hz];
  UNTIL hz>=360;
END;

PROCEDURE CALC_spec;
VAR
  tot,band,delta,delta1,fr1,fr2 : single;
BEGIN
  reset(EEGf);
  FOR st:=1 TO 3 DO
  BEGIN
    c[st]:=0;
    FOR hz:=3 TO 360 DO spec[st,hz]:=0;
  END;

  FOR t:=1 TO 43200 DO
  BEGIN
    read(EEGf,spec4);
    IF (vs[t] IN ['w','n','r']) AND (vs[t]=vs[t-1]) AND (vs[t]=vs[t+1]) THEN
    BEGIN
      local:=0; FOR hz:=3 TO 180 DO local:=local+spec4.bin[hz];
      IF local>0 THEN                                             {skip -1.#QNAN}
      BEGIN
        IF (vs[t]='w') AND (local<4000) THEN                      {skip waking artefacts}
        BEGIN
          inc(c[1]); FOR hz:=3 TO 360 DO spec[1,hz]:=spec[1,hz]+spec4.bin[hz];
        END;
        IF vs[t]='n' THEN
        BEGIN
          inc(c[2]); FOR hz:=3 TO 360 DO spec[2,hz]:=spec[2,hz]+spec4.bin[hz];
        END;
        IF vs[t]='r' THEN
        BEGIN
          inc(c[3]); FOR hz:=3 TO 360 DO spec[3,hz]:=spec[3,hz]+spec4.bin[hz];
        END;
      END;
    END;
  END;
  close(EEGf);

  FOR hz:=3 TO 360 DO
  BEGIN
    FOR st:=1 TO 3 DO
    BEGIN
      spec[st,hz]:=spec[st,hz]*1000000/c[st];
      spec[st,hz]:=spec[st,hz]*100/ref;
    END;
  END;

  remove_art;

  write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
  IF (nID=92) AND (m=1) THEN writeln(OUTf,'-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12,
                                          '-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12,'-1.000':12)
  ELSE
  BEGIN
    {total power in state}
    tot:=0; FOR hz:=3 TO 320 DO tot:=tot+spec[2,hz];

    {delta   1.00 - 4.25 Hz}
    band:=0; FOR hz:= 4 TO 17   DO band:=band+spec[2,hz]; write(OUTf,band:12:4,band*100/tot:12:3); delta:=band;

    {delta slow   1.00 - 2.25 Hz}
    band:=0; FOR hz:= 4 TO 9   DO band:=band+spec[2,hz]; write(OUTf,band*100/tot:12:3); delta1:=band;
    {delta fast  2.50 - 4.25 Hz}
    band:=0; FOR hz:= 10 TO 17   DO band:=band+spec[2,hz]; write(OUTf,band*100/tot:12:3,band/delta1:12:4);
    band:=0; hz:=3;  REPEAT inc(hz); band:=band+spec[2,hz]; UNTIL band*2>delta; fr1:=hz;
    band:=0; hz:=18; REPEAT dec(hz); band:=band+spec[2,hz]; UNTIL band*2>delta; fr2:=hz;
    write(OUTf,(fr1+fr2)/8:12:3); write(fr1:12:1,fr2:12:1);

    {theta   5.00 - 9.00 Hz}
    band:=0; FOR hz:=20 TO 36   DO band:=band+spec[2,hz]; write(OUTf,band:12:4,band*100/tot:12:3);
    {sigma   11.00 - 16.00 Hz}
    band:=0; FOR hz:=44 TO 64   DO band:=band+spec[2,hz]; write(OUTf,band:12:4,band*100/tot:12:3);
    {beta    18.00 - 30 Hz}
    band:=0; FOR hz:=72 TO 120  DO band:=band+spec[2,hz]; write(OUTf,band:12:4,band*100/tot:12:3);
    {gamma-1 32.00- 55 Hz}
    band:=0; FOR hz:=128 TO 220 DO band:=band+spec[2,hz]; write(OUTf,band:12:4,band*100/tot:12:3);
    {gamma-2 55.25 - 80.00 Hz}
    band:=0; FOR hz:=221 TO 320 DO band:=band+spec[2,hz]; write(OUTf,band:12:4,band*100/tot:12:3);

    writeln(OUTf);
  END;
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir');                    reset(DIRf);
  assign(REFf,'D:\BXD Sinergia\phenotypes\BXD_EEGref.out');  reset(REFf); readln(REFf); {skip column names}
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_NREMS EEG bands.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,
               'delta':12,'delta%':12,'del_slow%':12,'del_fast%':12,'fast/slow':12,'del50%Hz':12,'theta':12,'theta%':12,'sigma':12,'sigma%':12,'beta':12,'beta%':12,'gamma1':12,'gamma1%':12,'gamma2':12,'gamma2%':12);

  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm);
      readln(REFf,info,ref); write(nID:4,fln:8,m:4);
      assign(EEGf,'D:\BXD Sinergia\smo123\'+fln+'.smo');
      READ_state;
      CALC_spec;
      writeln;
    END; {mouse}
  END; {strain}

  close(OUTf);
  close(REFf);
  close(DIRf);
END.