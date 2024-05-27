<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>  <!-- 페이지 설정: Java 언어, HTML 컨텐츠 타입, EUC-KR 인코딩 -->
<%@page import="jsp_test.Data"%>  <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 import -->
<%@page import="java.sql.*"%> <!-- SQL 관련 클래스 import -->
<%@page import="java.security.*"%>  <!-- 보안 관련 클래스 import -->

<%! 
	//비밀번호 해시 함수
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(password.getBytes());
        byte[] bytes = md.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="EUC-KR">
    <title>회원가입</title>
    <script>
    // 사용자 유형에 따라 추가적인 필드를 표시하거나 숨기는 함수
        function toggleUserTypeFields() {
            var userType = document.querySelector('select[name="user_type"]').value;
            // 필요한 경우, 사용자 유형에 따라 추가적인 필드 표시/숨기기
        }
    </script>
</head>
<body>
    <h1>회원가입</h1>
    <%
        String message = "";
        boolean isSubmitted = false;
        String userType = "";
     	// POST 요청 처리
        if ("POST".equalsIgnoreCase(request.getMethod())) {
        	// 폼 입력 값 가져오기
            String user_id = request.getParameter("user_id");
            String user_password = request.getParameter("user_password");
            String email = request.getParameter("email");
            String phone_number = request.getParameter("phone_number");
            userType = request.getParameter("user_type");
            Connection con = null;
            PreparedStatement pstmt = null;
            try {
            	// 데이터베이스 연결
                con = Data.getMySQLConnection();
             // 비밀번호 해시
                String hashedPassword = hashPassword(user_password);
             // 사용자 추가 쿼리 실행
                String query = "INSERT INTO User (user_id, user_password, email, phone_number, user_type, registration_date) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, user_id);
                pstmt.setString(2, hashedPassword);
                pstmt.setString(3, email);
                pstmt.setString(4, phone_number);
                pstmt.setString(5, userType);
                int result = pstmt.executeUpdate();
                // 결과 처리
                if(result > 0) {
                    message = "회원가입이 완료되었습니다.";
                    session = request.getSession();
                    session.setAttribute("user_id", user_id); 
                } else {
                    message = "회원가입 실패.";
                }
                isSubmitted = true;
            } catch (Exception e) {
                e.printStackTrace();
                message = "오류가 발생했습니다: " + e.getMessage();
            } finally {
            	// 자원 해제
                Data.close(pstmt);
                Data.close(con);
            }
        }
     // 폼이 제출되지 않은 경우, 회원가입 폼 표시
        if (!isSubmitted) {
    %>
            <form action="signup.jsp" method="post">
                아이디: <input type="text" name="user_id" /><br/>
                비밀번호: <input type="password" name="user_password" /><br/>
                이메일: <input type="email" name="email" /><br/>
                전화번호: <input type="text" name="phone_number" /><br/>
                사용자 유형:
                <select name="user_type" onchange="toggleUserTypeFields()">
                    <option value="expert">전문가</option>
                    <option value="user">일반 사용자</option>
                </select><br/>
                <input type="submit" value="회원가입" />
            </form>
    <%
        }else {
        	 // 폼 제출 후 결과 메시지 및 추가 버튼 표시
            out.print("<p>" + message + "</p>");
            out.print("<button onclick=\"location.href='MedicineSearch.jsp'\">이전</button>");
         // 전문가 인 경우, 전문가 인증 버튼 표시
            if ("expert".equals(userType)) {  // 전문가인 경우
                out.print("<button onclick=\"location.href='expert_verification.jsp'\">전문가 인증</button>");
            } 
        }
    %>
     <button onclick="location.href='MedicineSearch.jsp'">이전</button>  <!-- '이전' 버튼 추가 -->
</body>
</body>
</html>
