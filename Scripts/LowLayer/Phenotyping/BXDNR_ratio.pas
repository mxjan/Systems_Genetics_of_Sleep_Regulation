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
  strID                : string[10];
  mID                  : string[11];
  fln                  : string[5];
  str,numStr,m,numM,h,t,
  wc,nc,rc,so,vs,day,
  room,rec,worm,nID    : integer;
  remlocal,totlocal    : single;
  spec4                : epoch;
  rt                   : array[2..3,1..3,1..2] of integer;
  ratio                : array[2..3,1..3] of single;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_NR-ratio.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'ratLb':12,'ratDb':12,'rat24b':12,'ratLr':12,'ratDr':12,'rat18r':12,'ratLbr':12,'ratDbr':12,'rat24br':12);

  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm);
      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
      writeln(strID:10,fln:6);

      FOR vs:=2 TO 3 DO
      BEGIN
        FOR day:=1 TO 3 DO
        BEGIN
          FOR h:=1 to 2 DO rt[vs,day,h]:=0;
        END;
      END;

      assign(EEGf,'D:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);
      FOR day:=1 TO 2 DO
      BEGIN
        FOR h:=1 TO 2 DO
        BEGIN
          FOR t:=1 TO 10800 DO
          BEGIN
            read(EEGf,spec4);

            CASE spec4.state OF
              'n','2','5' : inc(rt[2,day,h]);
              'r','3','6' : inc(rt[3,day,h]);
            END;
          END;
        END;
      END;

      FOR t:=1 TO 5400 DO read(EEGf,spec4);   {skip SD}

      day:=3; h:=1;
      FOR t:=1 TO 5400 DO
      BEGIN
        read(EEGf,spec4);
        CASE spec4.state OF
          'n','2','5' : inc(rt[2,day,h]);
          'r','3','6' : inc(rt[3,day,h]);
        END;
      END;
      day:=3; h:=2;
      FOR t:=1 TO 10800 DO
      BEGIN
        read(EEGf,spec4);
        CASE spec4.state OF
          'n','2','5' : inc(rt[2,day,h]);
          'r','3','6' : inc(rt[3,day,h]);
        END;
      END;

      close(EEGf);

      FOR h:=1 TO 2 DO        {average 2 baseline days}
      BEGIN
        FOR vs:=2 TO 3 DO
        BEGIN
          rt[vs,2,h]:=round((rt[vs,1,h]+rt[vs,2,h])/2);
        END;
      END;

      FOR day:=2 TO 3 DO
      BEGIN;
        remlocal:=rt[3,day,1];
        totlocal:=rt[2,day,1]+rt[3,day,1];
        ratio[day,1]:=remlocal*100/totlocal;
        write(OUTf,ratio[day,1]:12:3);

        remlocal:=rt[3,day,2];
        totlocal:=rt[2,day,2]+rt[3,day,2];
        ratio[day,2]:=remlocal*100/totlocal;
        write(OUTf,ratio[day,2]:12:3);

        remlocal:=rt[3,day,1]+rt[3,day,2];
        totlocal:=rt[2,day,1]+rt[3,day,1]+rt[2,day,2]+rt[3,day,2];
        ratio[day,3]:=remlocal*100/totlocal;
        write(OUTf,ratio[day,3]:12:3);
      END;

      FOR h:=1 TO 3 DO write(OUTf,ratio[3,h]/ratio[2,h]:12:4);

      writeln(OUTf);

    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.