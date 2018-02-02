uses DRSC;

Var
	SCInfo	: TDRSC;
	
	i		: longint;
Begin
	SCInfo := TDRSC.Create();					//初始化类
	SCInfo.decimal:=3;							//保留三位小数 如果小于0则输出为科学计数法
	
	SCInfo.Add(0,1);							
	{
		参数 变速时间点 变成的下落速度 
		返回 TDRSC.Add 返回值为当前变速点为总共的第几个变速点。
		也就是第一次调用这个函数的时候 返回值为1
	}
	
	for i:=0 to 99 do begin						//你甚至可以这样操作
		SCInfo.Add(5+i*0.01,1+sqr(i/10))
	end;
	SCInfo.Add(6,1);
	
	SCInfo.Sort;								//排序
	SCInfo.ExportToConsole;						//输出到控制台
	//SCInfo.ExportToConsole('SCInfo.txt');		//输出到文件
	SCInfo.Destory;								//释放类
End.