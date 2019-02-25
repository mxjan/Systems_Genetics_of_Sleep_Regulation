PROGRAM NameXYZ;

USES
  strings;
TYPE
  epoch = Record
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
  wcr,ncr,rcr,local    : single;
  spec4                : epoch;
  h16                  : array[1..16] of single;


BEGIN
  assign(DIRf,'d:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'d:\BXD Sinergia\BXDr24bsl.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'h1':12,'h2':12,'h3':12,'h4':12,'h5':12,'h6':12,'h7':12,'h8':12,'h9':12,'h10':12,'h11':12,'h12':12,'h13':12,'h14':12,'h15':12,'h16':12);

  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm); writeln(strID:10,fln:6);
      assign(EEGf,'d:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);
      for h:=1 to 16 do h16[h]:=0;
      FOR day:=1 TO 2 DO
      BEGIN
        FOR h:=1 TO 16 DO
        BEGIN
          FOR t:=1 TO 1350 DO
          BEGIN
            read(EEGf,spec4);
            IF spec4.state in ['r','3','6'] then h16[h]:=h16[h]+1;
          END;
        END;
      END;
      close(EEGf);

      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
      FOR h:=1 TO 16 DO
      BEGIN
        h16[h]:=h16[h]/30; {to minutes and 2-day average}
        write(OUTf,h16[h]:12:3);
      END;
      writeln(OUTf);
    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.