<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jsp_test.Data"%> <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 -->
<%@ page import="java.util.List"%> <!-- 자바 유틸리티 클래스 중 리스트 사용 -->
<%@ page import="java.util.ArrayList"%> <!-- ArrayList 클래스 사용 -->
<%@ page import="java.sql.*"%> <!-- SQL 연결을 위한 클래스들 -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전문가 대시보드</title>
</head>
<body>
    <h1>전문가 대시보드</h1>
    <h2>약물 검색</h2>
    <%
         // 약물 이름을 저장할 리스트 선언
        List<String> drugList = new ArrayList<>();
 		// 데이터베이스 연결 및 쿼리 실행을 위한 변수 선언
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
        	// 데이터베이스 연결
            con = Data.getMySQLConnection();
        	 // 약물 이름을 조회하는 쿼리
            String query = "SELECT drug_name FROM drug";
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();
            // 결과 집합에서 약물 이름을 리스트에 추가
            while(rs.next()) {
                drugList.add(rs.getString("drug_name"));
            }
        } catch(SQLException e) {
        	 // SQL 오류 발생 시 처리
            e.printStackTrace();
        } finally {
        	 // 데이터베이스 연결 종료
            Data.close(rs);
            Data.close(pstmt);
            Data.close(con);
        }
    %>
    <!-- 약물 상호작용 검색 폼 -->
    <form action="interactionResult.jsp" method="post">
        약물 1: 
        <select name="drug1">
         <!-- 조회된 약물 목록으로 드롭다운 리스트 생성 -->
            <% for(String drug : drugList) { %>
                <option value="<%= drug %>"><%= drug %></option>
            <% } %>
        </select><br/>
        약물 2: 
        <select name="drug2">
            <% for(String drug : drugList) { %>
                <option value="<%= drug %>"><%= drug %></option>
            <% } %>
        </select><br/>
        <input type="submit" value="검색" />
    </form>
 <!-- 피드백 보내기 버튼 (ExpertFeedbackForm.jsp로 이동) -->
    <h2>약물 수정/추가 피드백 보내기</h2>
    <button onclick="window.location.href='ExpertFeedbackForm.jsp'">피드백 보내기</button>
     <h2>로그아웃</h2>
    <!-- 로그아웃 버튼 (logout.jsp로 이동) -->
    <button onclick="window.location.href='logout.jsp'">로그아웃</button>
</body>
</html>
