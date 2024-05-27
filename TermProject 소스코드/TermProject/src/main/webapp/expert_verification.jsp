<%@ page import="jsp_test.Data"%>   <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 -->
<%@ page import="java.sql.*"%>   <!-- SQL 연결을 위한 클래스들 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전문가 인증</title>
</head>
<body>
    <h1>전문가 인증</h1>
    <%
    
		 // 현재 로그인한 사용자의 ID를 세션에서 가져옴
        String userId = (String) session.getAttribute("user_id");
        String errorMessage = null;

     // 폼 제출 시 처리
        if ("POST".equalsIgnoreCase(request.getMethod())) {
        	// 폼 데이터에서 면허 번호 추출
            String licenseNumber = request.getParameter("license_number");
            Connection con = null;
            PreparedStatement pstmt = null;

            try {
            	// 데이터베이스 연결
                con = Data.getMySQLConnection();
             // 전문가 인증 요청을 데이터베이스에 삽입
                String query = "INSERT INTO ExpertVerification_Requests (user_id, license_number, request_status) VALUES (?, ?, 'Pending')";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, userId);
                pstmt.setString(2, licenseNumber);
                pstmt.executeUpdate();
            } catch (Exception e) {
            	// 오류 발생 시 처리
                errorMessage = "오류가 발생했습니다: " + e.getMessage();
                e.printStackTrace();
            } finally {
            	 // 데이터베이스 연결 종료
                Data.close(pstmt);
                Data.close(con);
            }
        }

        // 에러 메시지 표시
        if (errorMessage != null) {
            %><p><%= errorMessage %></p><%
        } else if ("POST".equalsIgnoreCase(request.getMethod())) {
        	 // 폼 제출 성공 시 메시지 표시
            %><p>의사 면허 번호 제출이 완료되었습니다.</p><%
        } else {
        	// 폼 표시
            %>
            <form action="expert_verification.jsp" method="post">
                의사 면허 번호: <input type="text" name="license_number"><br/>
                <input type="submit" value="제출">
            </form>
            <%
        }
    %>
</body>
</html>
