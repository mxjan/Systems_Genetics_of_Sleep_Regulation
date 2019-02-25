PROGRAM Delta;

USES
  strings;
TYPE
  epoch = Record
            state          : char;
            bin            : array[0..400] of single;
            EEGv,EMGv,temp : single;
          end;
VAR
  DIRf,OUTf                : text;
  EEGf                     : file of epoch;
  strID                    : string[10];
  mID                      : string[11];
  fln                      : string[5];
  str,numStr,m,numM,nID,
  room,rec,worm,so         : integer;

  spec4                    : epoch;
  day,ld,hz,t,ts,nc,s,e,
  intl,numint,rest,h       : integer;
  ref2                     : single;
  vs                       : array[0..21601] of boolean;
  timar,delar              : array[1..4,1..18] of single;


PROCEDURE CALC_ref;
VAR
  local,del                : single;
  ref                      : array[1..2] of single;
BEGIN
  FOR day:=1 TO 2 DO
  BEGIN
    ts:=(day-1)*21600+7200; seek(EEGf,ts-1);
    FOR t:=0 TO 3601 DO
    BEGIN
      read(EEGf,spec4);
      IF spec4.state='n' THEN vs[t]:=true ELSE vs[t]:=false;
    END;

    ref[day]:=0; nc:=0;
    seek(EEGf,ts);
    FOR t:=1 TO 3600 DO
    BEGIN
      read(EEGf,spec4);
      IF vs[t-1] AND vs[t] AND vs[t+1] THEN
      BEGIN
        inc(nc);
        local:=0; for hz:=4 to 16 do local:=local+spec4.bin[hz];
        local:=local*1000000/13;
        ref[day]:=ref[day]+local;
      END;
    END;
    ref[day]:=ref[day]/nc;
  END;

  CASE nID OF
     4 : begin if m=3 then ref2:=ref[2] else ref2:=(ref[1]+ref[2])/2; end;
     7 : begin if m=1 then ref2:=ref[2] else ref2:=(ref[1]+ref[2])/2; end;
    31 : begin if m=7 then ref2:=ref[2] else ref2:=(ref[1]+ref[2])/2; end;
    45 : begin if m=1 then ref2:=ref[2] else ref2:=(ref[1]+ref[2])/2; end;
    48 : begin if m in [2,3,4] then ref2:=ref[2] else ref2:=(ref[1]+ref[2])/2; end;
    69 : begin if m=5 then ref2:=ref[2] else ref2:=(ref[1]+ref[2])/2; end;
    80 : begin if m=6 then ref2:=ref[2] else ref2:=(ref[1]+ref[2])/2; end;
    95 : begin if m=2 then ref2:=ref[2] else ref2:=(ref[1]+ref[2])/2; end;
    ELSE ref2:=(ref[1]+ref[2])/2;
  END;

END;

PROCEDURE READ_vs;
BEGIN
  ts:=(day-1)*21600; seek(EEGf,ts);
  FOR t:=1 TO 21600 DO
  BEGIN
    read(EEGf,spec4);
    IF spec4.state='n' THEN vs[t]:=true ELSE vs[t]:=false;
  END;
  vs[0]:=vs[1]; vs[21601]:=vs[21600];
END;

PROCEDURE CALC_intlength;
BEGIN
  nc:=0; t:=s;
  REPEAT
    inc(t);
    IF vs[t] AND vs[t-1] AND vs[t+1] THEN inc(nc);
  UNTIL t=e;
  intl:=nc DIV numint; rest:=nc MOD numint;
END;

PROCEDURE CALC_delta;
VAR
  del,local,tim : single;
  numi,hr       : integer;
BEGIN
  ts:=(day-1)*21600;
  nc:=0; del:=0; tim:=0; t:=s;
  FOR h:=1 TO numint DO
  BEGIN
    IF h<=rest THEN numi:=intl+1 ELSE numi:=intl;
    REPEAT
      inc(t);
      IF vs[t] AND vs[t-1] AND vs[t+1] THEN
      BEGIN
        inc(nc);
        seek(EEGf,(ts+t)-1); read(EEGf,spec4);
        local:=0; FOR hz:=4 to 16 DO local:=local+spec4.bin[hz];
        del:=del+local*1000000/13;
        tim:=tim+t;
      END;
    UNTIL (nc=numi) OR (t>=e);

    del:=del/nc; del:=del*100/ref2; tim:=tim/nc; tim:=tim/900;

    hr:=(ld-1)*12+h;
    delar[day,hr]:=del;
    timar[day,hr]:=tim;

    del:=0; nc:=0; tim:=0;
  END;
END;


BEGIN
  assign(DIRf,'d:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'d:\BXD Sinergia\phenotypes\BXDdeldyn2.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'del_1bsl':12,'del_1rec':12,'del_13bsl':12,'del13v12b':12,'del13vs18b':12);

  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm);

      writeln(strID:12,mID:12,m:4);
      assign(EEGf,'d:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);

      CALC_REF;

      FOR day:=1 TO 4 DO
      BEGIN
        READ_vs;
        FOR ld:=1 TO 2 DO
        BEGIN
          IF ld=1 THEN BEGIN numint:=12; s:=0; e:=10800; END ELSE BEGIN numint:=6; s:=10800; e:=21600; END;
          IF (ld=1) AND (day=3) THEN BEGIN s:=so; numint:=8; END;

          CALC_intlength;
          CALC_delta;
        END;
      END;
      close(EEGf);

      CASE nID OF
         4 : if m<>3 then for h:=1 to 18 do delar[2,h]:=(delar[1,h]+delar[2,h])/2;
         7 : if m<>1 then for h:=1 to 18 do delar[2,h]:=(delar[1,h]+delar[2,h])/2;
        31 : if m<>7 then for h:=1 to 18 do delar[2,h]:=(delar[1,h]+delar[2,h])/2;
        45 : if m<>1 then for h:=1 to 18 do delar[2,h]:=(delar[1,h]+delar[2,h])/2;
        48 : if NOT (m in [2,3,4]) then for h:=1 to 18 do delar[2,h]:=(delar[1,h]+delar[2,h])/2;
        69 : if m<>5 then for h:=1 to 18 do delar[2,h]:=(delar[1,h]+delar[2,h])/2;
        80 : if m<>6 then for h:=1 to 18 do delar[2,h]:=(delar[1,h]+delar[2,h])/2;
        95 : if m<>6 then for h:=1 to 18 do delar[2,h]:=(delar[1,h]+delar[2,h])/2;
        ELSE for h:=1 to 18 do delar[2,h]:=(delar[1,h]+delar[2,h])/2;
      END;

      writeln(OUTf,nID:4,strID:12,mID:12,m:5,room:5,rec:5,worm:5,delar[2,1]:12:4,delar[3,1]:12:4,delar[2,13]:12:4,delar[2,13]/delar[2,12]:12:4,delar[2,13]/delar[2,18]:12:4);
    END;
  END;
  close(DIRf);
  close(OUTf);
END.




