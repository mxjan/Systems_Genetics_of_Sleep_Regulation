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
  room,rec,worm,nID,
  local,durs,nums      : integer;
  dursr                : single;
  spec4                : epoch;
  ends                 : boolean;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXDseizures.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'num_seizur':12,'dur_seizur':12);

  readln(DIRf,numStr);
  FOR str:=1 TO numStr DO
  BEGIN
    readln(DIRf,nID,strID);
    readln(DIRf,numM);
    FOR m:=1 TO numM DO
    BEGIN
      readln(DIRf,mID,fln,so,room,rec,worm);
      write(OUTf,nID:4,strID:12,mID:12,m:4,room:5,rec:5,worm:5);

      assign(EEGf,'D:\BXD Sinergia\smo123\'+fln+'.smo'); reset(EEGf);
      seek(EEGf,43199); t:=0; nums:=0; durs:=0;
      REPEAT
        ends:=false;
        inc(t); read(EEGf,spec4);
        IF spec4.state = 's' THEN
        BEGIN
          inc(nums);
          local:=1;
          REPEAT
            inc(t); read(EEGf,spec4);
            IF spec4.state = 's' THEN inc(local) ELSE ends:=true;
          UNTIL ends;
          durs:=durs+local;
        END;
      UNTIL t>=21600;
      writeln(strID:10,fln:6,t:6,nums:6);

      IF nums>0 THEN
      BEGIN
        dursr:=durs; dursr:=dursr/nums; dursr:=dursr*4;
      END
      ELSE dursr:=-1.0;
      writeln(OUTf,nums:12,dursr:12:2);
    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.