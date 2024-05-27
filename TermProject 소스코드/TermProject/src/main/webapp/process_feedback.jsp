<%@ page import="jsp_test.Data"%>  <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 -->
<%@ page import="java.sql.*"%>   <!-- SQL 관련 클래스 import -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  <!-- 페이지 설정: Java 언어, HTML 컨텐츠 타입, UTF-8 인코딩 -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">  <!-- 문자 인코딩 설정 -->
    <title>피드백 처리 결과</title>
</head>
<body>
    <%
		 // 파라미터에서 피드백 ID, 액션, 새 약물 이름, 클래스, 선택된 약물 ID 받기
        int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
        String action = request.getParameter("action");
        String newDrugName = request.getParameter("new_drug_name");
        String newDrugClass = request.getParameter("new_drug_class");
        String selectedDrugId = request.getParameter("drug_id");

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = Data.getMySQLConnection();

            // 피드백 상태 업데이트
            String query = "UPDATE drug_feedback SET status = ? WHERE feedback_id = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, action.equals("Approve") ? "Approved" : "Denied");
            pstmt.setInt(2, feedbackId);
            pstmt.executeUpdate();
            pstmt.close();

            if (action.equals("Approve")) {
                if (selectedDrugId != null && !selectedDrugId.isEmpty()) {
                    // 기존 약물 정보 수정
                    query = "UPDATE drug SET drug_name = ?, modification_date = CURRENT_TIMESTAMP WHERE drug_id = ?";
                    pstmt = con.prepareStatement(query);
                    pstmt.setString(1, newDrugName);
                    pstmt.setInt(2, Integer.parseInt(selectedDrugId));
                    pstmt.executeUpdate();
                } else {
                    // 새 약물 추가
                    query = "INSERT INTO drug (drug_name, registration_date) VALUES (?, CURRENT_TIMESTAMP)";
                    pstmt = con.prepareStatement(query);
                    pstmt.setString(1, newDrugName);
                    pstmt.executeUpdate();

                    // 새로 추가된 약물의 ID 가져오기
                    ResultSet generatedKeys = pstmt.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        int newDrugId = generatedKeys.getInt(1);

                        // drug_classification 테이블 업데이트
                        query = "INSERT INTO drug_classification (drug_id, class_name, registration_date) VALUES (?, ?, CURRENT_TIMESTAMP)";
                        pstmt = con.prepareStatement(query);
                        pstmt.setInt(1, newDrugId);
                        pstmt.setString(2, newDrugClass);
                        pstmt.executeUpdate();
                    }
                }
            }

            out.println("<p>피드백이 '" + action + "' 처리되었습니다.</p>");  // 결과 메시지 출력
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");  // 오류 메시지 출력
        } finally {
            Data.close(rs);
            Data.close(pstmt);
            Data.close(con);
        }
    %>
    <button onclick="window.location.href='admin_dashboard.jsp'">대시보드로 돌아가기</button>  <!-- 대시보드로 돌아가기 버튼 -->
</body>
</html>
