<%@ page import="jsp_test.Data"%>  <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 -->
<%@ page import="java.sql.*"%>  <!-- SQL 연결을 위한 클래스들 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>사용자 피드백</title>
</head>
<body>
    <h1>사용자 피드백</h1>

    <%
   		 // 데이터베이스 연결 설정
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
        	// 데이터베이스 연결
            con = Data.getMySQLConnection();
         	// 사용자 피드백 조회 쿼리
            String feedbackQuery = "SELECT user_id, message, submission_date FROM Feedback";
            pstmt = con.prepareStatement(feedbackQuery);
         	// 쿼리 실행
            rs = pstmt.executeQuery();

            // 결과 처리
            while (rs.next()) {
            	// 각 피드백 정보 추출
                String userId = rs.getString("user_id");
                String message = rs.getString("message");
                String submissionDate = rs.getString("submission_date");
                %>
                <div>
                	<!-- 피드백 정보 표시 -->
                    <p>User ID: <%= userId %></p>
                    <p>Message: <%= message %></p>
                    <p>Submission Date: <%= submissionDate %></p>
                </div>
                <hr>
                <%
            }
        } catch (SQLException e) {
        	 // SQL 오류 처리
            e.printStackTrace();
        } finally {
        	 // 데이터베이스 연결 종료
            Data.close(rs);
            Data.close(pstmt);
            Data.close(con);
        }
    %>
</body>
</html>
