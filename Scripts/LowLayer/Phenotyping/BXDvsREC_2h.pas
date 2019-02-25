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
  rt                   : array[1..3,1..4,1..12] of integer;
  rtb                  : array[1..3,1..12] of single;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXDvsREC2hN.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'r4d':12,'r5d':12,'r6d':12,'r7d':12,'r8d':12,'r9d':12,'r10d':12,'r11d':12,'r12d':12,'r13d':12,'r14d':12,'r15d':12);

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
          FOR h:=1 to 8 DO rt[vs,day,h]:=0;
        END;
      END;

      assign(EEGf,'D:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);
      FOR day:=1 TO 4 DO
      BEGIN
        FOR h:=1 TO 12 DO
        BEGIN
          FOR t:=1 TO 1800 DO
          BEGIN
            read(EEGf,spec4);
            CASE spec4.state OF
              'w','1','4' : inc(rt[1,day,h]);
              'n','2','5' : inc(rt[2,day,h]);
              'r','3','6' : inc(rt[3,day,h]);
            END;
          END;
        END;
      END;
      close(EEGf);

      FOR h:=1 TO 12 DO
      BEGIN
        FOR vs:=1 TO 3 DO
        BEGIN
          rtb[vs,h]:=rt[vs,1,h]+rt[vs,2,h];
          rtb[vs,h]:=rtb[vs,h]/2;
        END;
      END;

      {FOR vs:=1 TO 3 DO}
      vs:=2;
      BEGIN
        FOR h:=4 to 12 DO
        BEGIN
          local:=rt[vs,3,h]; local:=local-rtb[vs,h]; write(OUTf,local/15:12:3);
        END;
        FOR h:=1 to 3 DO
        BEGIN
          local:=rt[vs,4,h]; local:=local-rtb[vs,h]; write(OUTf,local/15:12:3);
        END;
      END;
      writeln(OUTf);

    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.