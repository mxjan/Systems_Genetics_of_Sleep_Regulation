PROGRAM activity;

USES
  strings;
TYPE
  epoch = Record
            state          : char;
            bin            : array[0..400] of single;
            EEGv,EMGv,temp : single;
          end;
VAR
  EEGf                     : file of epoch;
  spec4                    : epoch;
  dirf1,dirf2,outf,ACTf    : text;
  ACTfln,strID             : string;
  EEGfln                   : string[5];
  mID                      : string[11];
  numl,line,numM,m,day,l,h,
  t,c,nID,wc,so,room,rec,
  worm,vs                  : integer;
  act,actm                 : single;
  h12                      : array[1..4,1..2] of single;
  local                    : array[1..2] of single;  

BEGIN
  assign(dirf1,'d:\bxd sinergia\acteeg.dir'); reset(dirf1);
  assign(dirf2,'d:\bxd sinergia\bxd.dir'); reset(dirf2);
  assign(outf,'d:\bxd sinergia\phenotypes\actwak1224bsl.out'); rewrite(outf);
  writeln(outf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'act24':12,'w24':12,'relact24':12,'act12L':12,'w12L':12,'relact12L':12,'act12D':12,'w12D':12,'relact12D':12);

  readln(dirf1);
  readln(dirf2,numl);
  FOR line:=1 TO numl DO
  BEGIN
    readln(dirf1);
    readln(dirf1);
    readln(dirf2,nID,strID);
    readln(dirf2,numM);
    FOR m:=1 TO numM DO
    BEGIN
      writeln(strID:10,m:4);

      readln(dirf1,ACTfln); trimright(ACTfln);
      assign(actf,'d:\bxd sinergia\act\'+ACTfln+'.act'); reset(ACTf);

      FOR day:=1 TO 4 DO
      BEGIN
        FOR t:=1 TO 1440 DO readln(ACTf);
      END;

      actm:=0; c:=0; h:=0; t:=0;
      REPEAT
        inc(t);
        read(ACTf,l,act);
        IF act>-1.0 THEN BEGIN actm:=actm+act; inc(c); END;
        IF t=720 THEN
        BEGIN
          inc(h);
          h12[h,1]:=actm; h12[h,1]:=h12[h,1]*720/c;
          t:=0; c:=0; actm:=0;
        END;
      UNTIL (eof(ACTf)) OR (h=4);
      close(ACTf);

      readln(dirf2,mID,EEGfln,so,room,rec,worm); trimright(EEGfln);
      assign(EEGf,'d:\BXD Sinergia\smo123\'+EEGfln+'.smo'); reset(EEGf);
      wc:=0; t:=0; h:=0;
      REPEAT
        inc(t);
        read(EEGf,spec4);
        IF spec4.state in ['w','1','4'] THEN inc(wc);
        IF t=10800 THEN
        BEGIN
          inc(h);
          h12[h,2]:=wc; h12[h,2]:=h12[h,2]/900;
          t:=0; wc:=0;
        END;
      UNTIL (eof(EEGf)) OR (h=4);
      close(EEGf);

      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
      FOR vs:=1 TO 2 DO
      BEGIN
        local[vs]:=(h12[1,vs]+h12[2,vs]+h12[3,vs]+h12[4,vs])/2;
        write(OUTf,local[vs]:12:3);
      END;
      write(OUTf,local[1]/local[2]:12:3);

      FOR vs:=1 TO 2 DO
      BEGIN
        local[vs]:=(h12[1,vs]+h12[3,vs])/2;
        write(OUTf,local[vs]:12:3);
      END;
      write(OUTf,local[1]/local[2]:12:3);

      FOR vs:=1 TO 2 DO
      BEGIN
        local[vs]:=(h12[2,vs]+h12[4,vs])/2;
        write(OUTf,local[vs]:12:3);
      END;
      writeln(OUTf,local[1]/local[2]:12:3);

    END; {mouse}
  END;

  close(outf);
  close(dirf1);
  close(dirf2);
END.