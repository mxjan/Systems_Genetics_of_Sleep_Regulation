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
  dif                  : single;
  spec4                : epoch;
  rt                   : array[1..3,1..4,1..4] of integer;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXDvsRECdifx.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'w2d':12,'w3d':12,'w4d':12,'w5d':12,'w3+4d':12,'w2+3+4d':12,'w2+3+4+5d':12,
                                                                               'n2d':12,'n3d':12,'n4d':12,'n5d':12,'n3+4d':12,'n2+3+4d':12,'n2+3+4+5d':12,
                                                                               'r2d':12,'r3d':12,'r4d':12,'r5d':12,'r3+4d':12,'r2+3+4d':12,'r2+3+4+5d':12);

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
            END
          END;
        END;
      END;
      close(EEGf);

      FOR h:=1 TO 4 DO
      BEGIN
        FOR vs:=1 TO 3 DO
        BEGIN
          rt[vs,2,h]:=round((rt[vs,1,h]+rt[vs,2,h])/2);
        END;
      END;

      FOR vs:=1 TO 3 DO
      BEGIN
        FOR h:=2 TO 4 DO BEGIN dif:=(rt[vs,3,h]-rt[vs,2,h]); write(OUTf,dif/15:12:3); END;
        dif:=(rt[vs,4,1]-rt[vs,2,1]); write(OUTf,dif/15:12:3);
        dif:=(rt[vs,3,3]+rt[vs,3,4])-(rt[vs,2,3]+rt[vs,2,4]); write(OUTf,dif/15:12:3);
        dif:=(rt[vs,3,2]+rt[vs,3,3]+rt[vs,3,4])-(rt[vs,2,2]+rt[vs,2,3]+rt[vs,2,4]); write(OUTf,dif/15:12:3);
        dif:=(rt[vs,3,2]+rt[vs,3,3]+rt[vs,3,4]+rt[vs,4,1])-(rt[vs,2,1]+rt[vs,2,2]+rt[vs,2,3]+rt[vs,2,4]); write(OUTf,dif/15:12:3);
      END;
      writeln(OUTf);

    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.