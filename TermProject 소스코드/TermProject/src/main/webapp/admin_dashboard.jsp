<%@ page import="jsp_test.Data"%>
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
</head>
<body>
    <h1>관리자 대시보드</h1>

    <!-- 전문가 인증 요청 보기 버튼 -->
    <h2>전문가 인증 요청</h2>
    <form action="expert_requests.jsp" method="post">
        <input type="submit" value="전문가 인증 요청 보기" />
    </form>

    <!-- 사용자 피드백 보기 버튼 -->
    <h2>사용자 피드백</h2>
    <form action="feedback.jsp" method="post">
        <input type="submit" value="사용자 피드백 보기" />
    </form>

    <!-- 전문가 피드백 보기 버튼 -->
    <h2>전문가 피드백</h2>
    <form action="admin_feedback_review.jsp" method="post">
        <input type="submit" value="전문가 피드백 보기" />
    </form>

    <h2>로그아웃</h2>
    <!-- 로그아웃 버튼 -->
    <button onclick="window.location.href='logout.jsp'">로그아웃</button>
</body>
</html>
