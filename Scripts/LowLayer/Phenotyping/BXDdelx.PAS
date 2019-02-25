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
  DIRf,OUTf            : text;
  EEGf                 : file of epoch;
  strID                : string[10];
  mID                  : string[11];
  fln                  : string[5];
  str,numStr,m,numM,nID,
  room,rec,worm,so     : integer;


PROCEDURE CALC;
VAR
  ts,hz,t,day,nc : integer;
  local,ref2,del,sor : single;
  ref            : array[1..2] of single;
  vs             : array[0..3601] of boolean;
  spec4          : epoch;
BEGIN
  FOR day:=1 TO 2 DO
  BEGIN
    ts:=7200+(day-1)*21600;
    seek(EEGf,ts-2);
    FOR t:=0 TO 3601 DO
    BEGIN
      read(EEGf,spec4);
      IF spec4.state='n' THEN vs[t]:=true ELSE vs[t]:=false;
    END;

    ref[day]:=0; nc:=0;
    seek(EEGf,ts-1);
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
    write(ref[day]:12:4,nc:5);
  END;
  ref2:=(ref[1]+ref[2])/2;
  writeln(ref2:12:4);

  ts:=2*21600+so;
  seek(EEGf,ts-2);
  FOR t:=0 TO 3601 DO
  BEGIN
    read(EEGf,spec4);
    IF spec4.state='n' THEN vs[t]:=true ELSE vs[t]:=false;
  END;

  del:=0; nc:=0; t:=0;
  seek(EEGf,ts-1);
  REPEAT
    inc(t);
    read(EEGf,spec4);
    IF vs[t-1] AND vs[t] AND vs[t+1] THEN
    BEGIN
      inc(nc);
      local:=0; for hz:=4 to 16 do local:=local+spec4.bin[hz];
      local:=local*1000000/13;
      del:=del+local;
    END;
  UNTIL (nc=300) OR (t>900);

  del:=del/nc;
  del:=del*100/ref2;
  sor:=so; sor:=(sor-5400)/15;
  writeln(OUTf,ref[1]:12:4,ref[2]:12:4,ref2:12:4,nc:12,t:12,del:12:4,sor:12:3);
END;


BEGIN
  assign(DIRf,'d:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'d:\BXD Sinergia\phenotypes\BXDdel20m.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'ref1':12,'ref2':12,'ref':12,'nc':12,'t':12,'del':12,'so':12);

  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm); writeln(strID:10,fln:6);
      assign(EEGf,'d:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);

      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
      write(strID:12,mID:12,m:4);
      CALC;
      close(EEGf);
    END;
  END;
  close(DIRf);
  close(OUTf);
END.







