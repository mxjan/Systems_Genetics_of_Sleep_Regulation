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
  local                : single;
  spec4                : epoch;
  rt                   : array[1..3,1..4,1..4] of integer;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXDvsREC.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'w1':12,'w2':12,'w3':12,'w4':12,'w5':12,'w3+4':12,'w2+3+4':12,'w2+3+4+5':12,
                                                                               'n1':12,'n2':12,'n3':12,'n4':12,'n5':12,'n3+4':12,'n2+3+4':12,'n2+3+4+5':12,
                                                                               'r1':12,'r2':12,'r3':12,'r4':12,'r5':12,'r3+4':12,'r2+3+4':12,'r2+3+4+5':12);

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

      FOR vs:=1 TO 3 DO
      BEGIN
        FOR day:=1 TO 4 DO
        BEGIN
          FOR h:=1 to 4 DO rt[vs,day,h]:=0;
        END;
      END;

      assign(EEGf,'D:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);
      FOR day:=1 TO 4 DO
      BEGIN
        FOR h:=1 TO 4 DO
        BEGIN
          FOR t:=1 TO 5400 DO
          BEGIN
            read(EEGf,spec4);
            CASE spec4.state OF
              'w','1','4' : inc(rt[1,day,h]);
              'n','2','5' : inc(rt[2,day,h]);
              'r','3','6' : inc(rt[3,day,h]);

            ELSE writeln(str:10,m:3);  END
          END;
        END;
      END;
      close(EEGf);

      FOR vs:=1 TO 3 DO
      BEGIN
        FOR h:=1 to 4 DO
        BEGIN
          local:=rt[vs,3,h];                                write(OUTf,local/15:12:3);
        END;
        local:=rt[vs,4,1];                                  write(OUTf,local/15:12:3);
        local:=rt[vs,3,3]+rt[vs,3,4];                       write(OUTf,local/15:12:3);
        local:=rt[vs,3,2]+rt[vs,3,3]+rt[vs,3,4];            write(OUTf,local/15:12:3);
        local:=rt[vs,3,2]+rt[vs,3,3]+rt[vs,3,4]+rt[vs,4,1]; write(OUTf,local/15:12:3);
      END;
      writeln(OUTf);

    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.