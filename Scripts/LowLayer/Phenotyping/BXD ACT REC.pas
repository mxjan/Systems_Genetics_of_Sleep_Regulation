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
  h12                      : array[1..8,1..2] of single;
  actLb,actDb,wakLb,wakDb,
  ratLb,ratDb,local        : single;


BEGIN
  assign(dirf1,'d:\bxd sinergia\acteeg.dir'); reset(dirf1);
  assign(dirf2,'d:\bxd sinergia\bxd.dir'); reset(dirf2);
  assign(outf,'d:\bxd sinergia\phenotypes\BXDactrec.out'); rewrite(outf);
  writeln(outf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'actR1D':12,'actR1Dr':12,'actR1D/b':12,'actR1Dr/b':12,
                                                                               'actR2L':12,'actR2Lr':12,'actR2L/b':12,'actR2Lr/b':12,
                                                                               'actR2D':12,'actR2Dr':12,'actR2D/b':12,'actR2Dr/b':12);

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
      UNTIL (eof(ACTf)) OR (h=8);
      close(ACTf);

      readln(dirf2,mID,EEGfln,so,room,rec,worm); trimright(EEGfln);
      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
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
      UNTIL (eof(EEGf)) OR (h=8);
      close(EEGf);

      actLb:=(h12[1,1]+h12[3,1])/2;
      actDb:=(h12[2,1]+h12[4,1])/2;
      wakLb:=(h12[1,2]+h12[3,2])/2;
      wakDb:=(h12[2,2]+h12[4,2])/2;
      ratLb:=actLb/wakLb;
      ratDb:=actDb/wakDb;

      FOR h:=6 TO 8 DO
      BEGIN
        local:=h12[h,1]/h12[h,2];
        write(OUTf,h12[h,1]:12:1,local:12:3);
        IF h=7 THEN write(OUTf,h12[h,1]*100/actLb:12:3,local*100/ratLb:12:3)
        ELSE write(OUTf,(h12[h,1]*100/actDb):12:3,local*100/ratDb:12:3);
      END;
      writeln(OUTf);
    END; {mouse}
  END;
  close(outf);
  close(dirf1);
  close(dirf2);
END.