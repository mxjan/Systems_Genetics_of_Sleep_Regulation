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
  str,numStr,m,numM,ld,
  t,so,vs,day,room,rec,
  worm,nID,vs1,i,cl    : integer;
  spec4                : epoch;
  c                    : array[1..3] of integer;
  phaseday,ampliday,
  phamday              : array[1..3] of single;
  shit                 : array[1..3,1..2160] of byte;


PROCEDURE READ_STATE;
BEGIN
  FOR vs1:=1 TO 3 DO
  BEGIN
    c[vs1]:=0;
    FOR i:=1 TO 2160 DO shit[vs1,i]:=0;
  END;

  FOR i:=1 TO 1440 DO
  BEGIN
    FOR t:=1 TO 15 DO
    BEGIN
      read(EEGf,spec4);
      CASE spec4.state OF
        'w','1','4' : BEGIN inc(c[1]); inc(shit[1,i]); END;
        'n','2','5' : BEGIN inc(c[2]); inc(shit[2,i]); END;
        'r','3','6' : BEGIN inc(c[3]); inc(shit[3,i]); END;
      END;
    END;
  END;
  FOR i:=1441 TO 2160 DO FOR vs1:=1 TO 3 DO shit[vs1,i]:=shit[vs1,i-1440];
END;

PROCEDURE GRAVITY;
VAR
  maxdif,mindif,phasemin,phasemax,difmin,difmax,cd : integer;
BEGIN
  FOR vs1:=1 TO 3 DO
  BEGIN
    maxdif:=-10800; mindif:=10800;
    FOR t:=1 TO 1080 DO
    BEGIN
      cl:=0; FOR i:=t TO (t+719) DO cl:=cl+shit[vs1,i];
      cd:=c[vs1]-cl;
      difmin:=abs(cl-cd);
      IF vs1=1 THEN difmax:=cl-cd ELSE difmax:=cd-cl;
      IF difmin<mindif THEN BEGIN mindif:=difmin; phasemin:=t; END;
      IF difmax>maxdif THEN BEGIN maxdif:=difmax; phasemax:=t; END;
    END;

    IF phasemin>1440 THEN phasemin:=phasemin-1440;
    phasemin:=phasemin-720;
    IF phasemax>1440 THEN phasemax:=phasemax-1440;
    phasemax:=phasemax-720;
    writeln(day:2,' max: ',maxdif:8,phasemax:8);
    writeln(day:2,' min: ',mindif:8,phasemin:8);

    phaseday[vs1]:=phaseday[vs1]+phasemin;
    ampliday[vs1]:=ampliday[vs1]+maxdif;
    phamday[vs1]:=phamday[vs1]+phasemax;
  END;
END;


BEGIN
  assign(DIRf,'D:\BXD Sinergia\BXD.dir'); reset(DIRf);
  assign(OUTf,'D:\BXD Sinergia\phenotypes\BXD_POG.out'); rewrite(OUTf);
  writeln(OUTf,'nID':4,'line':12,'mouseID':11,'m#':5,'room':5,'rec':5,'worm':5,'Min_Ph_w':12,'Max_Ph_w':12,'Max_Amp_w':12,'Min_Ph_n':12,'Max_Ph_n':12,'Max_Amp_n':12,'Min_Ph_r':12,'Max_Ph_r':12,'Max_Amp_r':12);

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
        phaseday[vs1]:=0;
        ampliday[vs1]:=0;
        phamday[vs1]:=0;
      END;

      FOR day:=1 TO 2 DO
      BEGIN
        READ_STATE;
        GRAVITY;
      END;
      close(EEGf);

      FOR vs1:=1 TO 3 DO
      BEGIN
        phaseday[vs1]:=phaseday[vs1]/2; phaseday[vs1]:=phaseday[vs1]/60;
        phamday[vs1]:=phamday[vs1]/2; phamday[vs1]:=phamday[vs1]/60;
        ampliday[vs1]:=ampliday[vs1]/2; ampliday[vs1]:=ampliday[vs1]/900;
        write(OUTf,phaseday[vs1]:12:3,phamday[vs1]:12:3,ampliday[vs1]:12:3);
      END;
      writeln(OUTf);

      writeln(strID:10,fln:6);
    END; {mouse}
  END; {strain}
  close(DIRf);
  close(OUTf);
END.