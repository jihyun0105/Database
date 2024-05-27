<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  <!-- 페이지 설정: Java 언어, HTML 컨텐츠 타입, UTF-8 인코딩 -->
<%@ page import="jsp_test.Data"%> <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 import -->
<%@ page import="java.util.List"%><!-- List  클래스 import -->
<%@ page import="java.util.ArrayList"%> <!-- List 및 ArrayList 클래스 import -->
<%@ page import="java.sql.*"%> <!-- SQL 관련 클래스 import -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"> <!-- 문자 인코딩 설정 -->
    <title>사용자 대시보드</title>
</head>
<body>
    <h1>약물 검색</h1>
    <%
 // 약물 목록을 저장하기 위한 ArrayList 생성
        List<String> drugList = new ArrayList<>();
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

            // ResultSet에서 약물 이름을 drugList에 추가
            while(rs.next()) {
                drugList.add(rs.getString("drug_name"));
            }
        } catch(SQLException e) {
        	// SQL 예외 처리
            e.printStackTrace();
        } finally {
        	// 자원 해제
            Data.close(rs);
            Data.close(pstmt);
            Data.close(con);
        }
    %>
    <!-- 약물 상호작용 검색 폼 -->
    <form action="interactionResult.jsp" method="post">
    <!-- 첫 번째 약물 선택 드롭다운 -->
        약물 1: 
        <select name="drug1">
            <% for(String drug : drugList) { %>
                <option value="<%= drug %>"><%= drug %></option>
            <% } %>
        </select><br/>
        <!-- 두 번째 약물 선택 드롭다운 -->
        약물 2: 
        <select name="drug2">
            <% for(String drug : drugList) { %>
                <option value="<%= drug %>"><%= drug %></option>
            <% } %>
        </select><br/>
        <!-- 검색 버튼 -->
        <input type="submit" value="검색" />
    </form>

    <h2>피드백 보내기</h2>
    <!-- 피드백 보내기 버튼 -->
  <button onclick="window.location.href='FeedbackForm.jsp'">피드백 보내기</button>
   <h2>로그아웃</h2>
    <!-- 로그아웃 버튼 -->
    <button onclick="window.location.href='logout.jsp'">로그아웃</button>
</body>
</html>
