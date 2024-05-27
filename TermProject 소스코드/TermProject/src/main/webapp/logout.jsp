<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그아웃</title>
</head>
<body>
    <%
        // 세션을 가져온다
        session = request.getSession(false);
        if (session != null) {
            // 세션을 무효화한다
            session.invalidate();
        }

        // 로그인 페이지로 리디렉션한다
        response.sendRedirect("login.jsp"); // 로그인 페이지로 리디렉션
      
    %>
</body>
</html>
