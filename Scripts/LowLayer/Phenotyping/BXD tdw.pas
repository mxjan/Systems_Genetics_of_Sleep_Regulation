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
  str,numStr,m,numM,ld,t,
  wc,nc,rc,so,vs,day,
  room,rec,worm,nID    : integer;
  tdwc,wakc,artc       : array[1..2] of integer;
  spec4                : epoch;
  ratio,wak,tdw,art,
  tot,local            : single;



PROCEDURE calcper;
VAR
  hz,peakf          : integer;
  peakp,theta,total : single;
BEGIN
  peakp:=0;
  FOR hz:=14 TO 60 DO                                                        {determine peak frequency between 3.5 and 15 Hz}
  BEGIN
    IF spec4.bin[hz]>peakp THEN
    BEGIN
      peakp:=spec4.bin[hz];
      peakf:=hz;
    END;
  END;

  IF (peakf>26) AND (peakf<48) THEN                                          {peak frequency has to be >6.5 Hz and <12 Hz}
  BEGIN
    theta:=0; FOR hz:=(peakf-4) TO (peakf+4) DO theta:=theta+spec4.bin[hz];  {theta band 2.25 Hz broad adjusted according to peak frequency}
    total:=0; FOR hz:=14 TO 180 DO total:=total+spec4.bin[hz];               {total power 3.5 - 45 Hz}
    ratio:=theta/total;
  END
  ELSE ratio:=0;
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_TDWhx.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'TDW_Lbh':12,'TDW_Lb%':12,'TDW_Dbh':12,'TDW_Db%':12,'TDW_SDh':12,'TDW_SD%':12,'TDW_Lrh':12,'TDW_Lr%':12,'TDW_Drh':12,'TDW_Dr%':12,'TDW_Drb%':12);

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
      FOR ld:=1 TO 2 DO
      BEGIN
        tdwc[ld]:=0; wakc[ld]:=0; artc[ld]:=0;
      END;

      FOR day:=1 TO 2 DO
      BEGIN
        FOR ld:=1 TO 2 DO
        BEGIN
          FOR t:=1 TO 10800 DO
          BEGIN
            read(EEGf,spec4);
            IF spec4.state='w' THEN
            BEGIN
              calcper;
              IF ratio>0.228 THEN inc(tdwc[ld])
              ELSE inc(wakc[ld]);
            END;
            IF spec4.state in ['1','4'] THEN inc(artc[ld]);
          END;
        END;
      END;
      FOR ld:=1 TO 2 DO
      BEGIN
        tdw:=tdwc[ld]; tdw:=tdw/2;
        wak:=wakc[ld]; wak:=wak/2;
        art:=artc[ld]; art:=art/2;
        wak:=wak+art*(1.0-tdw/(wak+tdw));
        tdw:=tdw+art*(tdw/(wak+tdw));
        wak:=wak/900; tdw:=tdw/900; tot:=wak+tdw;
        write(OUTf,tdw:12:3,tdw*100/tot:12:3);
      END;

      FOR ld:=1 TO 2 DO
      BEGIN
        tdwc[1]:=0; wakc[1]:=0; artc[1]:=0;
        FOR t:=1 TO 5400 DO
        BEGIN
          read(EEGf,spec4);
          IF spec4.state='w' THEN
          BEGIN
            calcper;
            IF ratio>0.228 THEN inc(tdwc[1])
            ELSE inc(wakc[1]);
          END;
          IF spec4.state in ['1','4'] THEN inc(artc[1]);
        END;
        tdw:=tdwc[1]; tdw:=tdw;
        wak:=wakc[1]; wak:=wak;
        art:=artc[1]; art:=art;
        wak:=wak+art*(1.0-tdw/(wak+tdw));
        tdw:=tdw+art*(tdw/(wak+tdw));
        wak:=wak/900; tdw:=tdw/900; tot:=wak+tdw;
        write(OUTf,tdw:12:3,tdw*100/tot:12:3);
      END;

      tdwc[1]:=0; wakc[1]:=0; artc[1]:=0;
      FOR t:=1 TO 10800 DO
      BEGIN
        read(EEGf,spec4);
        IF spec4.state='w' THEN
        BEGIN
          calcper;
          IF ratio>0.228 THEN inc(tdwc[1])
          ELSE inc(wakc[1]);
        END;
        IF spec4.state in ['1','4'] THEN inc(artc[1]);
      END;
      tdw:=tdwc[1]; tdw:=tdw;
      wak:=wakc[1]; wak:=wak;
      art:=artc[1]; art:=art;
      wak:=wak+art*(1.0-tdw/(wak+tdw));
      tdw:=tdw+art*(tdw/(wak+tdw));
      wak:=wak/900; tdw:=tdw/900; tot:=wak+tdw;
      write(OUTf,tdw:12:3,tdw*100/tot:12:3);
      local:=tdw*100/tot;

      tdw:=tdwc[2]; tdw:=tdw/2;
      wak:=wakc[2]; wak:=wak/2;
      art:=artc[2]; art:=art/2;
      wak:=wak+art*(1.0-tdw/(wak+tdw));
      tdw:=tdw+art*(tdw/(wak+tdw));
      wak:=wak/900; tdw:=tdw/900; tot:=wak+tdw;
      local:=local*100/(tdw*100/tot);
      writeln(OUTf,local:12:3);
      close(EEGf);
      writeln(strID:10,fln:6);
    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.