{$MODE DELPHI}

unit DRSC;


interface
	uses
		sysutils,classes,windows;
		
	Type
		SVPoinit=Record
					time,Speed:Real;
				End;
		TSVPoint=^SVPoinit;
		TDRSC=Class
			Private
				//Fdecimal	:	longint;
				SCPointsList : TList;
			Public
				//Property decimal : longint read Fdecimal write Fdecimal;
				decimal : longint;
				constructor Create(); virtual;
				destructor Destory(); virtual;
				Function Add(time,Speed:real):longint;
				Function Sort():longint;
				//Function ExportToClipboard:longint;
				Function ExportToFile(s:ansistring):longint;
				Function ExportToConsole():longint;
		End;

implementation
Function NumToChar(a:int64):string;
Begin
	str(a,result);
End;


Function RealToDisplay(a:real;b:longint):string;
Var
	display:string;
	i:longint;
Begin
	if a>=0 
		then display:=''
		else
		begin
			display:='-';
			a:=-a;
		end;
	
	display:=display+NumToChar(trunc(a));
	a:=(a-trunc(a))*10;
	
	if b<0 then b:=16;
	b:=min(b,16);
	if b<>0 then display:=display+'.';
	
	for i:=1 to b do begin
		display:=display+NumToChar(trunc(a));
		a:=(a-trunc(a))*10;
	end;
	
	result:=display;
	exit();
End;

Function Sort_Callback(item1,item2:pointer):longint;register;
Var
	p1,p2:TSVPoint;
Begin
	p1:=TSVPoint(item1);
	p2:=TSVPoint(item2);
	
	if p1^.time>p2^.time then begin
		result:=1;
		exit();
	end;
	if p1^.time<p2^.time then begin
		result:=-1;
		exit();
	end;
	result:=0;
End;

constructor TDRSC.Create();
Begin
	Self.decimal:=3;
	SCPointsList := TList.Create;
End;

destructor TDRSC.Destory();
Var
	i,count:longint;
	P:TSVPoint;
Begin
	Count:=Self.SCPointsList.Count;
	for I:=Count-1 downto 0 do
		begin
			P:=Self.SCPointsList.Items[I];
			Self.SCPointsList.Delete(I);
			DisPose(P);
		end;
	Self.SCPointsList.Free;
End;

Function TDRSC.Add(time,Speed:real):longint;
Var
	NP : TSVPoint;
Begin
	new(NP);
	NP^.time:=time;
	NP^.speed:=speed;
	Self.SCPointsList.Add(NP);
	result:=Self.SCPointsList.Count;
end;

Function TDRSC.Sort():longint;
Begin
	Self.SCPointsList.Sort(@Sort_Callback);
	result:=0;
end;

{
Function TDRSC.ExportToClipboard():longint;
//Var
//	hWndNewOwner : HWND;
Begin
	OpenClipboard()
End;
}

Function TDRSC.ExportToFile(s:ansistring):longint;
{
#SCN=1;
#SC [0]=1;
#SCI[0]=0.000
}
Var
	t	:	text;
	i	:	longint;
	P	:	TSVPoint;
Begin
	assign(t,s);rewrite(t);
	writeln(t,'#SCN='+NumToChar(Self.SCPointsList.Count));
	for i:=0 to Self.SCPointsList.Count-1 do begin
		P:=Self.SCPointsList.Items[i];
		if self.decimal<0 then begin
			writeln(t,'#SC [',i,']=',P^.Speed);
			writeln(t,'#SCI[',i,']=',P^.Time);
		end
		else
		begin
			writeln(t,'#SC [',i,']=',RealToDisplay(P^.Speed,self.decimal));
			writeln(t,'#SCI[',i,']=',RealToDisplay(P^.Time,self.decimal));
		end;
	end;
	close(t);
	result:=0;
End;

Function TDRSC.ExportToConsole():longint;
Var
	i	:	longint;
	P	:	TSVPoint;
Begin
	writeln('#SCN='+NumToChar(Self.SCPointsList.Count));
	for i:=0 to Self.SCPointsList.Count-1 do begin
		P:=Self.SCPointsList.Items[i];
		if self.decimal<0 then begin
			writeln('#SC [',i,']=',P^.Speed);
			writeln('#SCI[',i,']=',P^.Time);
		end
		else
		begin
			writeln('#SC [',i,']=',RealToDisplay(P^.Speed,self.decimal));
			writeln('#SCI[',i,']=',RealToDisplay(P^.Time,self.decimal));
		end;
	end;
	result:=0;
End;


End.