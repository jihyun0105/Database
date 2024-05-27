<%@ page import="jsp_test.Data"%>  <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 -->
<%@ page import="java.sql.*"%>    <!-- SQL 연결을 위한 클래스들 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전문가 인증 요청</title>
</head>
<body>
    <h1>전문가 인증 요청</h1>

    <%
    
 		// 데이터베이스 연결 및 쿼리 실행을 위한 변수 선언
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
        	// 데이터베이스 연결
            con = Data.getMySQLConnection();
         // 대기 중인 전문가 인증 요청을 조회하는 쿼리
            String query = "SELECT id, user_id, license_number, request_status FROM ExpertVerification_Requests WHERE request_status = 'Pending'";
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();

         // 결과 집합을 반복하여 각 요청을 화면에 표시
            while (rs.next()) {
            	 // 데이터베이스에서 정보 가져오기
                int requestId = rs.getInt("id");
                String userId = rs.getString("user_id");
                String licenseNumber = rs.getString("license_number");
                %>
                <div>
                <!-- 요청 정보 표시 -->
                    <p>Request ID: <%= requestId %></p>
                    <p>User ID: <%= userId %></p>
                    <p>License Number: <%= licenseNumber %></p>
                    <!-- 상태 업데이트 폼 -->
                    <form action="update_request_status.jsp" method="post">
                        <input type="hidden" name="request_id" value="<%= requestId %>">
                        <select name="request_status">
                            <option value="Approved">승인</option>
                            <option value="Denied">거부</option>
                        </select>
                        <input type="submit" value="상태 변경">
                    </form>
                </div>
                <hr>
                <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
         // SQL 오류 발생 시 처리
        } finally {
        	// 데이터베이스 연결 종료
            Data.close(rs);
            Data.close(pstmt);
            Data.close(con);
        }
    %>
</body>
</html>
