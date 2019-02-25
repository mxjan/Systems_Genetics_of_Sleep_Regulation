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
  t,c,nID,wc,so,room,rec,LD,
  worm,vs                  : integer;
  act,actm                 : single;
  act15,wak15              : array[1..4] of single;
  local                    : array[1..2] of single;


BEGIN
  assign(dirf1,'d:\bxd sinergia\acteeg.dir'); reset(dirf1);
  assign(dirf2,'d:\bxd sinergia\bxd.dir'); reset(dirf2);
  assign(outf,'d:\bxd sinergia\phenotypes\LDDLactwbsl.out'); rewrite(outf);
  writeln(outf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'actL1':12,'actL2':12,'actD1':12,'actD2':12,'wakL1':12,'wakL2':12,'wakD1':12,'wakD2':12,'actLD':12,'actDL':12,'wakLD':12,'wakDL':12);

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

      FOR h:=1 TO 4 DO act15[h]:=0;

      FOR day:=1 TO 2 DO
      BEGIN
        FOR LD:=1 TO 2 DO
        BEGIN
          actm:=0; c:=0;
          FOR t:=1 TO 90 DO
          BEGIN
            readln(ACTf,l,act);
            IF act>-1.0 THEN BEGIN actm:=actm+act; inc(c); END;
          END;
          h:=(ld-1)*2+1;
          act15[h]:=act15[h]+actm*90/c;

          FOR t:=1 TO 540 DO readln(ACTf);

          actm:=0; c:=0;
          FOR t:=1 TO 90 DO
          BEGIN
            readln(ACTf,l,act);
            IF act>-1.0 THEN BEGIN actm:=actm+act; inc(c); END;
          END;
          h:=(ld-1)*2+2;
          act15[h]:=act15[h]+actm*90/c;
        END;
      END;
      close(ACTf);
      FOR h:=1 TO 4 DO act15[h]:=act15[h]/2;

      readln(dirf2,mID,EEGfln,so,room,rec,worm); trimright(EEGfln);
      assign(EEGf,'d:\BXD Sinergia\smo123\'+EEGfln+'.smo'); reset(EEGf);

      FOR h:=1 TO 4 DO wak15[h]:=0;

      FOR day:=1 TO 2 DO
      BEGIN
        FOR LD:=1 TO 2 DO
        BEGIN
          wc:=0;
          FOR t:=1 TO 1350 DO
          BEGIN
            read(EEGf,spec4);
            IF spec4.state in ['w','1','4'] THEN inc(wc);
          END;
          h:=(ld-1)*2+1;
          wak15[h]:=wak15[h]+wc;

          FOR t:=1 TO 8100 DO read(EEGf,spec4);

          wc:=0;
          FOR t:=1 TO 1350 DO
          BEGIN
            read(EEGf,spec4);
            IF spec4.state in ['w','1','4'] THEN inc(wc);
          END;
          h:=(ld-1)*2+2;
          wak15[h]:=wak15[h]+wc;
        END;
      END;
      close(EEGf);
      FOR h:=1 TO 4 DO wak15[h]:=wak15[h]/30;


      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);

      FOR h:=1 TO 4 DO
      BEGIN
        write(OUTf,act15[h]:12:3);
      END;
      FOR h:=1 TO 4 DO
      BEGIN
        write(OUTf,wak15[h]:12:3);
      END;
      write(OUTf,(act15[3]-act15[2]):12:3);
      write(OUTf,(act15[4]-act15[1]):12:3);
      write(OUTf,(wak15[3]-wak15[2]):12:3);
      write(OUTf,(wak15[4]-wak15[1]):12:3);
      writeln(OUTf);

    END; {mouse}
  END;

  close(outf);
  close(dirf1);
  close(dirf2);
END.