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
  str,numStr,m,numM,h,t,nID,
  wc,nc,rc,so,vs,
  room,rec,worm        : integer;
  wcr,ncr,rcr,local    : single;
  spec4                : epoch;
  h12                  : array[1..4,1..3] of single;


BEGIN
  assign(DIRf,'d:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'d:\BXD Sinergia\phenotypes\BXDvs1224bsl.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'w24':12,'n24':12,'r24':12,'w12L':12,'n12L':12,'r12L':12,'w12D':12,'n12D':12,'r12D':12,'wD-L':12,'nL-D':12,'rL-D':12);

  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm); writeln(strID:10,fln:6);
      assign(EEGf,'d:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);

      t:=0; wc:=0; nc:=0; rc:=0; h:=0;
      REPEAT
        inc(t);
        read(EEGf,spec4);
        CASE spec4.state OF
          'w','1','4' : inc(wc);
          'n','2','5' : inc(nc);
          'r','3','6' : inc(rc);
        END;
        IF t=10800 THEN
        BEGIN
          inc(h);
          wcr:=wc; wcr:=wcr/15;
          ncr:=nc; ncr:=ncr/15;
          rcr:=rc; rcr:=rcr/15;
          h12[h,1]:=wcr;
          h12[h,2]:=ncr;
          h12[h,3]:=rcr;
          t:=0; wc:=0; nc:=0; rc:=0;
        END;
      UNTIL (eof(EEGf)) OR (h=4);
      close(EEGf);

      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);
      FOR vs:=1 TO 3 DO
      BEGIN
        local:=(h12[1,vs]+h12[2,vs]+h12[3,vs]+h12[4,vs])/2;
        write(OUTf,local:12:3);
      END;
      FOR vs:=1 TO 3 DO
      BEGIN
        local:=(h12[1,vs]+h12[3,vs])/2;
        write(OUTf,local:12:3);
      END;
      FOR vs:=1 TO 3 DO
      BEGIN
        local:=(h12[2,vs]+h12[4,vs])/2;
        write(OUTf,local:12:3);
      END;
      FOR vs:=1 TO 3 DO
      BEGIN
        local:=((h12[1,vs]-h12[2,vs])+(h12[3,vs]-h12[4,vs]))/2;
        IF vs=1 THEN local:=local*-1;
        write(OUTf,local:12:3);
      END;
      writeln(OUTf);

    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.
