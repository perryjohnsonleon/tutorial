<!--#include file="md5.asp" -->
<!--#include file="sha1.asp" -->
<!--#include file="chk_rights.asp" -->
<%
'===============================================================
'  Check User For PJblog2
'===============================================================
Dim UserID,memName,memStatus,memBlog_NO
memStatus="Guest"
function login(UserName,Password,blog_no)
 Dim validate,ReInfo,HashKey
 UserName=CheckStr(UserName)
 Password=CheckStr(Password)
' validate=trim(request.form("validate"))
 ReInfo=Array("錯誤信息","","MessageIcon",false)
 IF trim(UserName)=""  Then
	 ReInfo(0)="錯誤信息"
	 ReInfo(1)="<b>請將信息輸入完整</b><br/><a href=""javascript:history.go(-1);"">請返回重新輸入</a>"
	 ReInfo(2)="WarningIcon"
	 login=ReInfo
	 logout(false)
	 exit function
  end if

'  IF validate="" Then
'	  ReInfo(0)="錯誤信息"
'	  ReInfo(1)="<b>請輸入登錄驗證碼</b><br/><a href=""javascript:history.go(-1);"">請返回重新輸入</a>"
'	  ReInfo(2)="WarningIcon"
'	  login=ReInfo
'	  logout(false)
'     exit function
' end if
  
 if IsValidUserName(UserName)=false then
	 ReInfo(0)="錯誤信息"
	 ReInfo(1)="<b>非法用戶名！<br/>請嘗試使用其他用戶名！</b><br/><a href=""javascript:history.go(-1);"">單擊返回</a>"
	 ReInfo(2)="ErrorIcon"
	 login=ReInfo
	 logout(false)
	 exit function
 end if
 
'  IF cstr(lcase(Session("GetCode")))<>cstr(lcase(validate)) then
'	  ReInfo(0)="錯誤信息"
'	  ReInfo(1)="<b>驗證碼有誤，請返回重新輸入</b><br/><a href=""javascript:history.go(-1);"">請返回重新輸入</a>"
'	  ReInfo(2)="ErrorIcon"
'	  login=ReInfo
'	  logout(false)
'     exit function
'  end if
     HashKey=SHA1(randomStr(6)&now())
	   Dim memLogin
		 Set memLogin=Server.CreateObject("ADODB.Recordset")
		 SQL="SELECT Top 1 mem_Name,mem_Password,mem_salt,mem_Status,mem_LastIP,mem_lastVisit,mem_hashKey,mem_blog_no FROM blog_member WHERE mem_Name='"&UserName&"' AND mem_blog_NO=" & blog_no  
		 
     memLogin.Open SQL,conn,1,3
     SQLQueryNums=SQLQueryNums+1
     IF  memLogin.EOF And memLogin.BOF Then
         memLogin.Close
	       '進行MD5密碼驗證，轉換舊帳戶密碼驗證方式
	       dim strSalt
	       strSalt=randomStr(6)
	       if  not rights("super","blog_pass",UserName) then
             Conn.Execute ("INSERT INTO blog_member(mem_Name,mem_blog_no,mem_Password,mem_Sex,mem_salt,mem_Email,mem_HideEmail,mem_Status,mem_LastIP,mem_hashKey,mem_eBASName) Values ('"&UserName&"','" & blog_no & "','admin888',0,'"&strSalt&"','"&UserName&"@eabs.gov.tw',0,'Guest','"&getIP()&"','" & HashKey &"','" & session("ebas_blog_username") & "')")
		     else
             Conn.Execute ("INSERT INTO blog_member(mem_Name,mem_blog_no,mem_Password,mem_Sex,mem_salt,mem_Email,mem_HideEmail,mem_Status,mem_LastIP,mem_hashKey,mem_eBASName) Values ('"&UserName&"','" & blog_no & "','admin888',0,'"&strSalt&"','"&UserName&"@eabs.gov.tw',0,'SupAdmin','"&getIP()&"','" & HashKey &"','" & session("ebas_blog_username") & "')")		    	
		     end if
		     Response.Cookies(CookieName)("memName")=UserName
		     Response.Cookies(CookieName)("memblog_no")=blog_no
		     Response.Cookies(CookieName)("memHashKey")=HashKey
				 Response.Cookies(CookieName).Expires=Date+1
		     IF  Request.Form("KeepLogin")="1" then Response.Cookies(CookieName).Expires=Date+365
		     ReInfo(0)="登錄成功"
		     ReInfo(1)="<b>"&UserName&"</b>，歡迎你的再次光臨。<br/><a href=""default.asp"">點擊返回主頁</a>"
		     ReInfo(2)="MessageIcon"
	       ReInfo(3)=true
		 ELSE
         memLogin("mem_LastIP")=getIP()
         memLogin("mem_lastVisit")=now()
         memLogin("mem_hashKey")=HashKey
		     Response.Cookies(CookieName)("memName")=memLogin("mem_Name")
		     Response.Cookies(CookieName)("memblog_no")=blog_no	     
		     Response.Cookies(CookieName)("memHashKey")=HashKey
			   Response.Cookies(CookieName).Expires=Date+1
		     if  Request.Form("KeepLogin")="1" then Response.Cookies(CookieName).Expires=Date+365
		     memLogin.Update
		     ReInfo(0)="登錄成功"
		     ReInfo(1)="<b>"&memLogin("mem_Name")&"</b>，歡迎你的再次光臨。<br/><a href=""default.asp"">點擊返回主頁</a><meta http-equiv=""refresh"" content=""3;url=default.asp""/>"
		     ReInfo(2)="MessageIcon"
	       ReInfo(3)=true
		     memLogin.Close
		 END IF
		 Set memLogin=Nothing
     login=ReInfo
end  function

function login2(UserName,Password)
 Dim validate,ReInfo,HashKey
 UserName=CheckStr(UserName)
 Password=CheckStr(Password)
 
 ReInfo=Array("錯誤信息","","MessageIcon",false)
 IF trim(UserName)="" OR trim(Password)="" Then
	 ReInfo(0)="錯誤信息"
	 ReInfo(1)="<b>請將信息輸入完整</b><br/><a href=""javascript:history.go(-1);"">請返回重新輸入</a>"
	 ReInfo(2)="WarningIcon"
	 login2=ReInfo
	 logout(false)
	 UserRight(1)
	 exit function
  end if
 
 if IsValidUserName(UserName)=false then
	 ReInfo(0)="錯誤信息"
	 ReInfo(1)="<b>非法用戶名！<br/>請嘗試使用其他用戶名！</b><br/><a href=""javascript:history.go(-1);"">單擊返回</a>"
	 ReInfo(2)="ErrorIcon"
	 login2=ReInfo
	 logout(false)
	 UserRight(1)
	 exit function
 end if
 
         HashKey=SHA1(randomStr(6)&now())
	     Dim memLogin
		 Set memLogin=Server.CreateObject("ADODB.Recordset")
		 SQL="SELECT Top 1 mem_Name,mem_Password,mem_salt,mem_Status,mem_LastIP,mem_lastVisit,mem_hashKey FROM blog_member WHERE mem_Name='"&UserName&"' AND mem_salt<>''"
         memLogin.Open SQL,conn,1,3
         SQLQueryNums=SQLQueryNums+1
         IF memLogin.EOF And memLogin.BOF Then
           memLogin.Close
		 SQL="SELECT Top 1 mem_Name,mem_Password,mem_salt,mem_Status,mem_LastIP,mem_lastVisit,mem_hashKey FROM blog_member WHERE mem_Name='"&UserName&"' AND mem_Password='"&md5(Password)&"'"
           memLogin.Open SQL,conn,1,3
           SQLQueryNums=SQLQueryNums+1
		   IF memLogin.EOF AND memLogin.BOF Then
		    	ReInfo(0)="錯誤信息"
		     	ReInfo(1)="<b>用戶名與密碼錯誤</b><br/><a href=""javascript:history.go(-1);"">請返回重新輸入</a>"
		    	ReInfo(2)="ErrorIcon"
		    	logout(false)
	       Else
	           '進行MD5密碼驗證，轉換舊帳戶密碼驗證方式
	            dim strSalt
	            strSalt=randomStr(6)
	            memLogin("mem_salt")=strSalt
            	memLogin("mem_LastIP")=getIP()
            	memLogin("mem_lastVisit")=now()
            	memLogin("mem_hashKey")=HashKey
            	memLogin("mem_Password")=SHA1(Password&strSalt)
		    	memLogin.Update
		    	memName=memLogin("mem_Name")
		    	memStatus=memLogin("mem_Status")
		    	ReInfo(0)="登錄成功"
		    	ReInfo(1)="<b>"&memLogin("mem_Name")&"</b>，歡迎你的再次光臨。<br/><a href=""default.asp"">點擊返回主頁</a>"
		    	ReInfo(2)="MessageIcon"
	            ReInfo(3)=true
		   End IF
		 else
		   if memLogin("mem_Password")<>SHA1(Password&memLogin("mem_salt")) then
		    	ReInfo(0)="錯誤信息"
		     	ReInfo(1)="<b>用戶名與密碼錯誤</b><br/><a href=""javascript:history.go(-1);"">請返回重新輸入</a>"
		    	ReInfo(2)="ErrorIcon"
		    	logout(false)
		   else
		    	memName=memLogin("mem_Name")
		    	memStatus=memLogin("mem_Status")
		    	ReInfo(0)="登錄成功"
		    	ReInfo(1)="<b>"&memLogin("mem_Name")&"</b>，歡迎你的再次光臨。<br/><a href=""default.asp"">點擊返回主頁</a><meta http-equiv=""refresh"" content=""3;url=default.asp""/>"
		    	ReInfo(2)="MessageIcon"
	            ReInfo(3)=true
		   end if
		 end if
		 UserRight(1)
		 memLogin.Close
		 Set memLogin=Nothing
  login2=ReInfo
end function

sub checkCookies()
Dim Guest_IP,Guest_Browser,Guest_Refer
 Guest_IP=getIP()
 Guest_Browser=getBrowser(Request.ServerVariables("HTTP_USER_AGENT"))
 
'IF Session("GuestIP")<>Guest_IP Then
'	Conn.ExeCute("UPDATE blog_Info SET blog_VisitNums=blog_VisitNums+1")
'	SQLQueryNums=SQLQueryNums+1
'	getInfo(2)
'	Session("GuestIP")=Guest_IP
'	if blog_CountNum>0 then
'	    dim tmpC
'	    tmplC=conn.execute("select count(coun_ID) as cnt from [blog_Counter]")(0)
'		SQLQueryNums=SQLQueryNums+1
'		Guest_Refer=Trim(Request.ServerVariables("HTTP_REFERER"))
'		if tmpC>=blog_CountNum then
'	     dim tmpLC
'	     tmpLC=conn.execute("select top 1 coun_ID from [blog_Counter] order by coun_Time ASC")(0)
'      Conn.ExeCute("update [blog_Counter] set coun_Time="&IsJ&datetostr(Now(),"y-m-d h:I:S")&IsJ&",coun_IP='"&Guest_IP&"',coun_OS='"&Guest_Browser(1)&"',coun_Browser='"&Guest_Browser(0)&"',coun_Referer='"&HTMLEncode(CheckStr(Guest_Refer))&"' where coun_ID="&tmpLC)
'			 SQLQueryNums=SQLQueryNums+2
'	  else
'	  	 Conn.ExeCute("INSERT INTO blog_Counter(coun_IP,coun_OS,coun_Browser,coun_Referer) VALUES ('"&Guest_IP&"','"&Guest_Browser(1)&"','"&Guest_Browser(0)&"','"&HTMLEncode(CheckStr(Guest_Refer))&"')")
'	     SQLQueryNums=SQLQueryNums+1
'	  end if
'	end if
'End IF  

Dim tempName,tempHashKey
 tempName=CheckStr(Request.Cookies(CookieName)("memName"))
 tempHashKey=CheckStr(Request.Cookies(CookieName)("memHashKey"))
 if tempHashKey="" then 
  logout(false)
 else
  Dim CheckCookie
  Set CheckCookie=Server.CreateObject("ADODB.RecordSet")
  SQL="SELECT Top 1 mem_ID,mem_Name,mem_Password,mem_salt,mem_Status,mem_LastIP,mem_lastVisit,mem_hashKey FROM blog_member WHERE mem_Name='"&tempName&"' AND mem_hashKey='"&tempHashKey&"' AND mem_hashKey<>''"
  CheckCookie.Open SQL,Conn,1,1
  SQLQueryNums=SQLQueryNums+1
  If  CheckCookie.EOF AND CheckCookie.BOF Then
      logout(false)
  Else
'     UserID=CheckCookie("mem_ID")
'     if CheckCookie("mem_LastIP")<>Guest_IP Or isNull(CheckCookie("mem_LastIP")) then
'      logout(true)
'     else
      UserID=CheckCookie("mem_ID")
      memName=CheckStr(Request.Cookies(CookieName)("memName"))
      memStatus=CheckCookie("mem_Status")
      memBlog_NO=CheckStr(Request.Cookies(CookieName)("memBlog_No"))
'    end if
  end if
  CheckCookie.Close
  Set CheckCookie=Nothing
  end if

end sub

sub logout(clearHashKey)
 'on error Resume Next
 if clearHashKey  And  UserID<>"" then conn.Execute("UPDATE blog_member set mem_hashKey='' where mem_ID="&UserID)
 If Err Then err.Clear
 Response.Cookies(CookieName)("memName")=""
 Response.Cookies(CookieName)("memHashKey")="" 
 Response.Cookies(CookieName).expires = dateadd("d", -1, now())
 memStatus="Guest"
end sub
%>