<%@ page import="jsp_test.Data"%>  <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 import -->
<%@ page import="java.sql.*"%>  <!-- SQL 관련 클래스 import -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  <!-- 페이지 설정: Java 언어, HTML 컨텐츠 타입, UTF-8 인코딩 -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">  <!-- 문자 인코딩 설정 -->
    <title>전문가 인증 상태 업데이트</title>
</head>
<body>
    <%
 		// 요청 ID와 요청 상태를 폼에서 가져옴  
        String requestId = request.getParameter("request_id");
        String requestStatus = request.getParameter("request_status");
        Connection con = null;
        PreparedStatement pstmt = null;
        boolean isUpdated = false;  // 상태 업데이트 성공 여부 확인용

        try {
        	// 데이터베이스 연결
            con = Data.getMySQLConnection();
         // 자동 커밋 비활성화
            con.setAutoCommit(false);

            // ExpertVerification_Requests 테이블 업데이트
            String query = "UPDATE ExpertVerification_Requests SET request_status = ? WHERE id = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, requestStatus);
            pstmt.setString(2, requestId);
            int rowsAffected = pstmt.executeUpdate();

            // user 테이블의 access_level 및 modification_date 업데이트 (승인된 경우)
            if ("Approved".equals(requestStatus)) {
                String userUpdateQuery = "UPDATE user SET access_level = 'expert_access', modification_date = CURRENT_TIMESTAMP WHERE user_id = (SELECT user_id FROM ExpertVerification_Requests WHERE id = ?)";
                pstmt = con.prepareStatement(userUpdateQuery);
                pstmt.setString(1, requestId);
                pstmt.executeUpdate();
            }
         // 모든 변경 사항 커밋
            con.commit();
            isUpdated = rowsAffected > 0; // 업데이트 여부 확인
        } catch (SQLException e) {
            e.printStackTrace();
         // 오류 발생시 롤백
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException se) {
                    se.printStackTrace(); // 자동 커밋 다시 활성화
                }
            }
        } finally {
        	// 자원 해제
            if (pstmt != null) pstmt.close();
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }

     // 결과 메시지 출력
        if (isUpdated) {
            out.println("<p>전문가 인증 요청 상태가 '" + requestStatus + "'(으)로 변경되었습니다.</p>");
        } else {
            out.println("<p>상태 변경 과정에서 오류가 발생했습니다.</p>");
        }
    %>
     <!-- 인증 요청 목록 페이지로 돌아가는 버튼 -->
    <button onclick="location.href='expert_requests.jsp'">인증 요청 목록으로 돌아가기</button>
</body>
</html>
