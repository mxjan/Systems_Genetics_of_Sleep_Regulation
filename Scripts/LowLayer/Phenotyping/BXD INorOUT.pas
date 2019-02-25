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
  str,numStr,m,numM,ld,t,
  so,day,room,rec,worm,nID : integer;
  spec4                    : epoch;
  vs1,vs2                  : byte;
  vs                       : array [1..43201] of byte;
  c                        : array [1..3] of integer;
  trans                    : array [1..3,1..3] of integer;
  transr                   : array [1..3,1..3] of single;


PROCEDURE READ_STATE;
BEGIN
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
END;

PROCEDURE INOUT;
VAR
  tot : array[1..3] of single;
BEGIN
  FOR t:=1 TO 43200 DO
  BEGIN
    vs1:=vs[t]; vs2:=vs[t+1];
    inc(trans[vs1,vs2]);
  END;

  FOR vs1:=1 TO 3 DO
  BEGIN
    tot[vs1]:=0;
    FOR vs2:=1 TO 3 DO
    BEGIN
      transr[vs1,vs2]:=trans[vs1,vs2];
      tot[vs1]:=tot[vs1]+transr[vs1,vs2];
    END;
  END;
  
  FOR vs1:=1 TO 3 DO
  BEGIN
    FOR vs2:=1 TO 3 DO write(OUTf,transr[vs1,vs2]*100/tot[vs1]:12:4);
  END;
  writeln(OUTf);
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_INOUT.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'w_w':12,'w_n':12,'w_r':12,'n_w':12,'n_n':12,'n_r':12,'r_w':12,'r_n':12,'r_r':12);

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
      FOR vs1:=1 TO 3 DO
      BEGIN
        c[vs1]:=0;
        FOR vs2:=1 TO 3 DO trans[vs1,vs2]:=0;
      END;

      READ_STATE;
      close(EEGf);
      INOUT;
      writeln(strID:10,fln:6);
    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.