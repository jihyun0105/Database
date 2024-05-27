<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- 페이지 설정: Java 언어, HTML 컨텐츠 타입, UTF-8 인코딩 -->
<%@ page import="jsp_test.Data"%> <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 -->
<%@ page import="java.sql.*"%>  <!-- SQL 관련 클래스 import -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>약물 상호작용 결과</title>
</head>
<body>
    <h1>약물 상호작용 결과</h1>
    <%
 		// 요청으로부터 약물 이름 받기
        String drug1Name = request.getParameter("drug1");  // drug1의 이름을 받음
        String drug2Name = request.getParameter("drug2");  // drug2의 이름을 받음
     // DB 연결 및 쿼리 실행에 필요한 객체 초기화
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String interactionContent = ""; // 상호작용 내용을 저장할 변수
        String drug1SideEffects = "";  // drug1의 부작용 내용을 저장할 변수
        String drug2SideEffects = "";  // drug2의 부작용 내용을 저장할 변수
        
        // 로그인 상태에 따른 리디렉션 페이지 설정
        String redirectPage = "MedicineSearch.jsp"; // 로그인 하지 않은 경우 기본 리디렉션 페이지

        try {
        	// DB 연결
            con = Data.getMySQLConnection();

            // Drug1의 ID 찾기
            String query = "SELECT drug_id FROM drug WHERE drug_name = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, drug1Name);
            rs = pstmt.executeQuery();
            int drug1Id = 0;  // Drug1 ID 초기화
            if (rs.next()) {
                drug1Id = rs.getInt("drug_id");
            }
            Data.close(rs);  // ResultSet 닫기
            Data.close(pstmt);  // PreparedStatement 닫기

            // Drug2의 ID 찾기
            query = "SELECT drug_id FROM drug WHERE drug_name = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, drug2Name);
            rs = pstmt.executeQuery();
            int drug2Id = 0; // Drug2 ID 초기화
            if (rs.next()) {
                drug2Id = rs.getInt("drug_id");
            }
            Data.close(rs);  // ResultSet 닫기
            Data.close(pstmt);  // PreparedStatement 닫기
 
            // 상호작용 정보 조회
            if (drug1Id > 0 && drug2Id > 0) {
                query = "SELECT interaction_content FROM drug_interaction WHERE drug1_id = ? AND drug2_id = ?";
                pstmt = con.prepareStatement(query);
                pstmt.setInt(1, drug1Id);
                pstmt.setInt(2, drug2Id);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    interactionContent = rs.getString("interaction_content");
                }
                Data.close(rs);  // ResultSet 닫기
                Data.close(pstmt);  // PreparedStatement 닫기
            }

            // Drug1의 부작용 조회
            if (drug1Id > 0) {
                query = "SELECT side_effect_content FROM side_effect WHERE drug_id = ?";
                pstmt = con.prepareStatement(query);
                pstmt.setInt(1, drug1Id);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    drug1SideEffects = rs.getString("side_effect_content");
                }
                Data.close(rs);  // ResultSet 닫기
                Data.close(pstmt);  // PreparedStatement 닫기
            }

            // Drug2의 부작용 조회
            if (drug2Id > 0) {
                query = "SELECT side_effect_content FROM side_effect WHERE drug_id = ?";
                pstmt = con.prepareStatement(query);
                pstmt.setInt(1, drug2Id);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    drug2SideEffects = rs.getString("side_effect_content");
                }
                Data.close(rs);   // ResultSet 닫기
                Data.close(pstmt);  // PreparedStatement 닫기
            }

            // 세션에서 user_id를 가져와 access_level 확인
            session = request.getSession();
            if (session != null) {
                String userId = (String) session.getAttribute("user_id");
                if (userId != null) {
                    pstmt = con.prepareStatement("SELECT access_level FROM User WHERE user_id = ?");
                    pstmt.setString(1, userId);
                    rs = pstmt.executeQuery();
                if (rs.next()) {
                    String accessLevel = rs.getString("access_level");
                 // 전문가 대시보드 또는 일반 사용자 대시보드로 리디렉션 결정
                    if ("expert_access".equals(accessLevel)) {
                        redirectPage = "expert_dashboard.jsp";
                    }else {
                        redirectPage = "user_dashboard.jsp";
                    }
                }
            }
         }
        } catch(SQLException e) {
            e.printStackTrace();  // 오류 출력
        } finally {
        	// 자원 반환
            Data.close(rs);
            Data.close(pstmt);
            Data.close(con);
        }

     // 상호작용 내용 출력
        if (!interactionContent.isEmpty()) {
            out.println("<p>" + interactionContent + "</p>");
        } else {
            out.println("<p>해당하는 상호작용 정보가 없습니다.</p>");
        }

        // 각 약물의 부작용 정보 출력
        out.println("<h2>" + drug1Name + "의 부작용</h2>");
        if (!drug1SideEffects.isEmpty()) {
            out.println("<p>" + drug1SideEffects + "</p>");
        } else {
            out.println("<p>부작용 정보가 없습니다.</p>");
        }

        out.println("<h2>" + drug2Name + "의 부작용</h2>");
        if (!drug2SideEffects.isEmpty()) {
            out.println("<p>" + drug2SideEffects + "</p>");
        } else {
            out.println("<p>부작용 정보가 없습니다.</p>");
        }
    %>
    <button onclick="location.href='<%= redirectPage %>'">대시보드로 돌아가기</button>  <!-- 대시보드로 돌아가기 버튼 -->
</body>
</html>
