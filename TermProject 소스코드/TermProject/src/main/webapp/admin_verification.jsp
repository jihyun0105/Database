<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="jsp_test.Data"%> <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>관리자 인증</title>
</head>
<body>
    <h1>관리자 인증</h1>
    <%
   		 // 메시지 초기화
        String message = "";
		 // 현재 로그인된 사용자의 ID 확인
        String loggedInUserId = (session != null) ? (String) session.getAttribute("user_id") : null;

        // 로그인되지 않았을 경우 로그인 페이지로 리디렉션
        if (loggedInUserId == null) {
            response.sendRedirect("login.jsp"); // 로그인하지 않은 경우 로그인 페이지로 리디렉션
            return;
        }
        // POST 요청이 발생했을 때 관리자 인증키 처리
        if ("POST".equalsIgnoreCase(request.getMethod())) {
        	// 사용자가 입력한 관리자 인증키
            String adminKeyInput = request.getParameter("admin_key");

         // 데이터베이스 연결 및 쿼리 실행을 위한 변수 선언
            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
            	// 데이터베이스 연결 설정
                con = Data.getMySQLConnection();
                // 로그인된 사용자의 user_type 및 admin_key 조회
                String query = "SELECT user_type, admin_key FROM user WHERE user_id = ?";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, loggedInUserId);
                rs = pstmt.executeQuery();

             // 결과 집합 처리
                if (rs.next()) {
                	// 사용자 유형 및 데이터베이스에 저장된 관리자 인증키
                    String userType = rs.getString("user_type");
                    String adminKeyFromDB = rs.getString("admin_key");

                 // 관리자 인증 성공 시 대시보드로 리디렉션, 실패 시 오류 메시지 설정
                    if ("administrator".equals(userType) && adminKeyFromDB != null && adminKeyFromDB.equals(adminKeyInput)) {
                        response.sendRedirect("admin_dashboard.jsp");
                    } else {
                        message = "Invalid admin key.";
                    }
                } else {
                    message = "Invalid session.";
                }
            } catch (SQLException e) {
            	 // SQL 실행 중 오류 발생 시 오류 메시지 설정
                e.printStackTrace();
                message = "An error occurred.";
            } finally {
            	// 데이터베이스 연결 종료
                Data.close(rs);
                Data.close(pstmt);
                Data.close(con);
            }
        }
    %>
    <!-- 오류 메시지가 있을 경우 표시 -->
    <% if (!message.isEmpty()) { %>
        <p><%= message %></p>
    <% } %>
      <!-- 관리자 인증키 입력 폼 -->
    <form action="admin_verification.jsp" method="post">
        관리자 인증키: <input type="text" name="admin_key" /><br/>
        <input type="submit" value="인증" />
    </form>
</body>
</html>
