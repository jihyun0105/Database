<%@ page import="jsp_test.Data"%>
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>피드백 검토</title>
</head>
<body>
    <h1>피드백 검토</h1>
    <%
    // 데이터베이스 연결과 쿼리 실행을 위한 변수 선언
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
        	// 데이터베이스 연결 설정
            con = Data.getMySQLConnection();
         // 데이터베이스에서 'Pending' 상태의 피드백을 조회하는 쿼리
            String query = "SELECT * FROM drug_feedback WHERE status = 'Pending'";
            pstmt = con.prepareStatement(query);
            // 쿼리 실행 및 결과 저장
            rs = pstmt.executeQuery();

         // 결과 집합을 반복하여 각 피드백 항목을 HTML로 표시
            while (rs.next()) {
                int feedbackId = rs.getInt("feedback_id");
                String userId = rs.getString("user_id");
                String newDrugName = rs.getString("new_drug_name");
                String newDrugClass = rs.getString("new_drug_class");
                String feedbackContent = rs.getString("feedback_content");
                %>
                <div>
                 <!-- 각 피드백 항목 표시 -->
                    <p>Feedback ID: <%= feedbackId %></p>
                    <p>User ID: <%= userId %></p>
                    <p>New Drug Name: <%= newDrugName %></p>
                    <p>New Drug Class: <%= newDrugClass %></p>
                    <p>Feedback Content: <%= feedbackContent %></p>
                     <!-- 피드백 승인 또는 거부를 위한 폼 -->
                    <form action="process_feedback.jsp" method="post">
                        <input type="hidden" name="feedback_id" value="<%= feedbackId %>">
                        <input type="hidden" name="new_drug_name" value="<%= newDrugName %>">
                        <input type="hidden" name="new_drug_class" value="<%= newDrugClass %>">
                        <input type="submit" name="action" value="Approve">
                        <input type="submit" name="action" value="Deny">
                    </form>
                </div>
                <hr>
                <%
            }
        } catch (SQLException e) {
        	 // SQL 실행 중 오류 발생 시 오류 메시지 출력
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
