<%
  function rights(mode,p_idno,q_idno) 
        dim admin_role,list_manager 
        q_idno = trim(q_idno)
        p_idno = trim(p_idno)
        admin_role="tfl;z00wu;rhuang;spencer;charles;z00scl"
        select case p_idno
        case "mp_pass"
             list_manager = ";"&admin_role   
        case "chief1_pass"
             list_manager = "yalan312;amy.ch;"&admin_role
        case "chiefmail_pass"
             list_manager = "yangmano;h104;f119;"&admin_role
        case "chief_pass"
             list_manager = "no2206;shung;snoopy;"&admin_role
        case "auditsurvey_pass"
             list_manager = "h104;"&admin_role
        case "blog_pass"
             list_manager = ";"&admin_role
        case else
             list_manager = ";"&admin_role          
        end select
        rights = false
        if q_idno<>"" then 
           select case mode
                case "manager"                  
                      rights = (InStr(list_manager,q_idno)<>0) 
                case "super"
                      rights = (InStr(list_manager,q_idno)<>0) 
                case "uncheck"
                      rights = true
           end select       
        end if
        if q_idno="" and mode="uncheck"  then  rights = true       
  end function  
%>