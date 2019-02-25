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
  DIRf,OUTf                : text;
  EEGf                     : file of epoch;
  strID                    : string[10];
  mID                      : string[11];
  fln                      : string[5];
  str,numStr,m,numM,so,
  room,rec,worm,nID        : integer;
  t                        : integer;
  spec4                    : epoch;
  vsi                      : byte;
  vs                       : array [0..43201] of byte;
  c                        : array [1..3] of integer;


PROCEDURE READ_STATE;
BEGIN
 FOR vsi:=1 TO 3 DO c[vsi]:=0;
 FOR t:=1 TO 43200 DO
 BEGIN
   read(EEGf,spec4);
   CASE spec4.state OF
     'w','1','4' : BEGIN inc(c[1]); vs[t]:=1; END;
     'n','2','5' : BEGIN inc(c[2]); vs[t]:=2; END;
     'r','3','6' : BEGIN inc(c[3]); vs[t]:=3; END;
   END;
 END;
 vs[43201]:=vs[43200];
 vs[0]:=vs[1];
END;

PROCEDURE DET_DIS;
VAR
  dis       : array[1..3] of integer;
  local,tot : single;
BEGIN
  FOR vsi:=1 TO 3 DO dis[vsi]:=0;

  FOR t:=1 TO 43200 DO
  BEGIN
    IF vs[t] <> vs[t-1] THEN
    BEGIN
      vsi:=vs[t-1];
      inc(dis[vsi]);
    END;
  END;

  FOR vsi:=1 TO 3 DO
  BEGIN
    tot:=c[vsi]; tot:=tot/900;
    local:=dis[vsi];
    write(OUTf,dis[vsi]:12,local/tot:12:3,tot*60/local:12:3);
  END;
  writeln(OUTf);
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_num_ep_bsl.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'#w':12,'#w/h':12,'w_dur':12,'#n':12,'#n/h':12,'n_dur':12,'#r':12,'#r/h':12,'r_dur':12);

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
      READ_STATE;
      close(EEGf);
      DET_DIS;
      writeln(strID:10,fln:6);
    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.