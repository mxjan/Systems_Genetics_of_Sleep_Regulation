PROGRAM NameXYZ;

USES
  strings,math;
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
  vs                       : array[0..3601] of char;
  lbi,ubi,hz,day,c         : integer;
  lb,ub,hzr                : single;
  spec                     : array[1..3,3..360] of single;


PROCEDURE ipol1;
BEGIN
  ubi:=trunc(ub*4);
  FOR day:=1 TO 3 DO spec[day,ubi]:=(spec[day,ubi-1]+spec[day,ubi+1])/2;
END;

PROCEDURE ipol2;
VAR
  nbi : integer;
  dif : single;
BEGIN
  lbi:=trunc(lb*4);
  ubi:=trunc(ub*4);
  nbi:=(ubi)-lbi+2;
  FOR day:=1 TO 3 DO
  BEGIN
    dif:=(spec[day,(ubi+1)]-spec[day,(lbi-1)])/nbi;
    FOR hz:=lbi TO ubi DO spec[day,hz]:=dif*(hz-(lbi-1))+spec[day,lbi-1];
  END;
END;

PROCEDURE REMOVE_art;
VAR
  prev : single;
BEGIN
  {remove 75 - 77 Hz in all mice}
  lb:=75.00; ub:=77.00; ipol2;

  {mouse for which EEG is useless} {already taken care off in WRITE_spec}{
  if (nID=92) and (m=1) then FOR hz:=3 TO 360 DO FOR day:=1 TO 3 DO spec[day,hz]:=-1.00;
  }
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
END;

PROCEDURE CALC_spec;
VAR
  local          : single;
  pos,start,dur  : integer;
BEGIN
  pos:=(day-1)*21600;
  IF day=3 THEN BEGIN start:=pos+so; dur:=2700; END
  ELSE BEGIN start:=pos+7200; dur:=3600; END;

  seek(EEGf,start-1);
  FOR t:=1 TO dur DO BEGIN read(EEGf,spec4); vs[t]:=spec4.state END;
  vs[0]:=vs[1]; vs[dur+1]:=vs[dur];

  c:=0; FOR hz:=3 TO 360 DO spec[day,hz]:=0;
  seek(EEGf,start-1);
  FOR t:=1 TO dur DO
  BEGIN
    read(EEGf,spec4);
    IF (vs[t]='n') AND (vs[t-1]='n') AND (vs[t+1]='n') THEN
    BEGIN
      local:=0; FOR hz:=3 TO 180 DO local:=local+spec4.bin[hz];
      IF local>0 THEN                                             {skip -1.#QNAN}
      BEGIN
        inc(c);
        FOR hz:=3 TO 360 DO spec[day,hz]:=spec[day,hz]+spec4.bin[hz];
      END;
    END;
  END;

  FOR hz:=3 TO 360 DO
  BEGIN
    spec[day,hz]:=spec[day,hz]*1000000/c;
    spec[day,hz]:=spec[day,hz]*100/ref;
  END;
END;

PROCEDURE WRITE_spec;
VAR
  b,bf,ef,nf : integer;
  band       : array[2..3] of single;
BEGIN
  IF (nID=92) AND (m=1) THEN FOR b:=1 TO 24 DO write(OUTf,'-9.999':12)
  ELSE
  BEGIN
    FOR hz:=3 TO 360 DO spec[2,hz]:=(spec[1,hz]+spec[2,hz])/2;

    FOR b:=1 TO 8 DO
    BEGIN
      CASE b OF
        1 : begin bf:=  4; ef:= 17; end; {delta    1.00 -  4.25 Hz}
        2 : begin bf:=  4; ef:=  9; end; {delta-1  1.00 -  2.25 Hz}
        3 : begin bf:= 10; ef:= 17; end; {delta-2  2.50 -  4.25 Hz}
        4 : begin bf:= 20; ef:= 36; end; {theta    5.00 -  9.00 Hz}
        5 : begin bf:= 44; ef:= 64; end; {sigma   11.00 - 16.00 Hz}
        6 : begin bf:= 72; ef:=120; end; {beta    18.00 - 30.00 Hz}
        7 : begin bf:=128; ef:=220; end; {gamma-1 32.00 - 55.00 Hz}
        8 : begin bf:=221; ef:=320; end; {gamma-2 55.25 - 80.00 Hz}
      END;
      nf:=(ef-bf)+1;

      FOR day:=2 TO 3 DO
      BEGIN
        band[day]:=0; FOR hz:=bf TO ef DO band[day]:=band[day]+spec[day,hz];
        band[day]:=band[day]/nf; write(OUTf,band[day]:12:4);
      END;
      write(OUTf,log2(band[3]/band[2]):12:4);
    END;

  END;
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf); readln(DIRf,numStr);
  assign(REFf,'D:\BXD Sinergia\phenotypes\BXD_EEGref.out'); reset(REFf); readln(REFf); {skip column names}
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_NREMSspecSD.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,
               'del_b':12, 'del_r':12, 'del_rat':12,
               'del1_b':12,'del1_r':12,'del1_rat':12,
               'del2_b':12,'del2_r':12,'del2_rat':12,
               'the_b':12, 'the_r':12, 'the_rat':12,
               'sig_b':12, 'sig_r':12, 'sig_rat':12,
               'bet_b':12, 'bet_r':12, 'bet_rat':12,
               'gam1_b':12,'gam1_r':12,'gam1_rat':12,
               'gam2_b':12,'gam2_r':12,'gam2_rat':12);

  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm);
      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
      readln(REFf,info,ref);

      assign(EEGf,'D:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);
      FOR day:=1 TO 3 DO CALC_spec;
      close(EEGf);

      REMOVE_art;
      WRITE_spec;
      writeln(OUTf);
      writeln(nID:4,fln:8,m:4);
    END; {mouse}
  END; {strain}

  close(OUTf); close(REFf); close(DIRf);
END.