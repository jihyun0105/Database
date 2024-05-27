<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  <!-- 페이지 설정: Java 언어, HTML 컨텐츠 타입, UTF-8 인코딩 -->
<%@ page import="jsp_test.Data"%>  <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 -->
<%@ page import="java.util.List"%>  <!-- Java의 List 컬렉션 클래스 사용 -->
<%@ page import="java.util.ArrayList"%>  <!-- Java의 ArrayList 컬렉션 클래스 사용 -->
<%@ page import="java.sql.*"%>  <!-- SQL 관련 클래스 import -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"> <!-- 문자 인코딩 설정 -->
    <title>약물 검색 시스템</title>
</head>
<body>
    <h1>약물 검색 시스템</h1>
    <%
        List<String> drugList = new ArrayList<>(); // 약물 이름을 저장할 리스트
        Connection con = null;  // DB 연결 객체
        PreparedStatement pstmt = null;  // SQL 실행 객체
        ResultSet rs = null;  // 결과셋 객체

        try {
        	 // DB 연결
            con = Data.getMySQLConnection();
            String query = "SELECT drug_name FROM drug";  // 약물 이름 조회 쿼리
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();

         // 결과셋에서 약물 이름을 리스트에 추가
            while(rs.next()) {
                drugList.add(rs.getString("drug_name"));
            }
        } catch(SQLException e) {
            e.printStackTrace();  // 오류 출력
        } finally {
        	// 자원 반환
            Data.close(rs);
            Data.close(pstmt);
            Data.close(con);
        }
    %>
    <form action="interactionResult.jsp" method="post">
        약물 1: 
        <select name="drug1">
            <% for(String drug : drugList) { %>
                <option value="<%= drug %>"><%= drug %></option>  <!-- 약물 이름을 옵션으로 표시 -->
            <% } %>
        </select><br/>
        약물 2: 
        <select name="drug2">
            <% for(String drug : drugList) { %>
                <option value="<%= drug %>"><%= drug %></option>   <!-- 약물 이름을 옵션으로 표시 -->
            <% } %>
        </select><br/>
        <input type="submit" value="검색" />  <!-- 검색 버튼 -->
    </form>
    <button onclick="location.href='login.jsp'">로그인</button>  <!-- 로그인 페이지로 이동하는 버튼 -->
    <button onclick="location.href='signup.jsp'">회원가입</button>  <!-- 회원가입 페이지로 이동하는 버튼 -->
</body>
</html>
