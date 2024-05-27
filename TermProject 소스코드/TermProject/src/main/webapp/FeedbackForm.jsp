<%@ page import="javax.servlet.http.HttpSession"%><!-- 세션 관련 클래스 import -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- 페이지 설정: Java 언어, HTML 컨텐츠 타입, UTF-8 인코딩 -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"> <!-- 문자 인코딩 설정 -->
    <title>피드백 제출</title>
</head>
<body>
    <h1>피드백 제출</h1>
    <%
    	// 현재 세션 가져오기. 세션이 없다면 null 반환
        session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            // 사용자가 로그인하지 않은 경우의 처리
            out.println("<p>로그인이 필요합니다.</p>");
            %><a href="login.jsp"><button>로그인 화면으로 이동</button></a><%  // 로그인 페이지로 이동하는 링크
        } else {
            %>
            <form action="SubmitFeedback.jsp" method="post">  <!-- 피드백 제출 폼 -->
                <label for="message">피드백 메시지:</label><br>  <!-- 피드백 메시지 라벨 -->
                <textarea name="message" id="message" rows="4" cols="50"></textarea><br>  <!-- 피드백 내용 입력 -->
                <input type="submit" value="피드백 제출"> <!-- 제출 버튼 -->
             
            </form>
            <%
        }
    %>
</body>
</html>
