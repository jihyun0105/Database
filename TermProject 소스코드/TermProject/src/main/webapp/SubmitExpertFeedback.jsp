<%@ page import="jsp_test.Data"%>  <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 import -->
<%@ page import="java.sql.*"%>  <!-- SQL 관련 클래스 import -->
<%@ page import="javax.servlet.http.HttpSession"%>  <!-- HttpSession 클래스 import -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  <!-- 페이지 설정: Java 언어, HTML 컨텐츠 타입, UTF-8 인코딩 -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">  <!-- 문자 인코딩 설정 -->
    <title>전문가 피드백 제출 결과</title>
</head>
<body>
    <%
 		// 세션을 확인하여 로그인 여부 확인
        session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
        	 // 로그인하지 않은 경우, 로그인 페이지로 리디렉션
            out.println("<p>로그인이 필요합니다.</p>");
            %><a href="login.jsp"><button>로그인 화면으로 이동</button></a><%
            return;
        }
     // 세션에서 사용자 ID를 가져옴
        String userId = (String) session.getAttribute("user_id");
     // 폼에서 입력된 데이터 가져옴
        String newDrugName = request.getParameter("new_drug_name");
        String newDrugClass = request.getParameter("new_drug_class");
        String feedbackContent = request.getParameter("feedback_content");
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
        	// 데이터베이스 연결
            con = Data.getMySQLConnection();
            // 피드백 정보를 drug_feedback 테이블에 삽입하는 쿼리
            String query = "INSERT INTO drug_feedback (user_id, new_drug_name, new_drug_class, feedback_content, status) VALUES (?, ?, ?, ?, 'Pending')";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, userId);
            pstmt.setString(2, newDrugName);
            pstmt.setString(3, newDrugClass);
            pstmt.setString(4, feedbackContent);
            int result = pstmt.executeUpdate();

         // 결과에 따른 메시지 출력
            if (result > 0) {
                out.println("<p>피드백이 성공적으로 제출되었습니다.</p>");
            } else {
                out.println("<p>피드백 제출에 실패했습니다.</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
        } finally {
        	// 자원 해제
            Data.close(pstmt);
            Data.close(con);
        }
    %>
    <!-- 대시보드로 돌아가기 버튼 추가 -->
    <button onclick="window.location.href='expert_dashboard.jsp'">대시보드로 돌아가기</button>
</body>
</html>
