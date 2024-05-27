<%@ page import="javax.servlet.http.HttpSession, java.util.List, java.util.ArrayList"%> <!-- 세션 및 필요한 유틸리티 클래스들을 가져옴 -->
<%@ page import="jsp_test.Data"%> <!-- 데이터베이스 연결을 위한 사용자 정의 클래스 -->
<%@ page import="java.sql.*"%> <!-- SQL 연결을 위한 클래스들 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전문가 피드백 제출</title>
    <script>
    
    // 드롭다운에서 분류를 선택할 때 텍스트 필드를 업데이트하는 함수
        function handleClassSelection() {
            var selectBox = document.getElementById("drug_class_select");
            var textBox = document.getElementById("new_drug_class");
            if(selectBox.value) {
                textBox.value = selectBox.value;
            } else {
                textBox.value = "";
            }
        }
        // 텍스트 필드에 입력할 때 드롭다운을 초기화하는 함수
        function handleClassInput() {
            var selectBox = document.getElementById("drug_class_select");
            var textBox = document.getElementById("new_drug_class");
            if(textBox.value) {
                selectBox.selectedIndex = 0; // 선택을 '분류 선택'으로 초기화
            }
        }
    </script>
</head>
<body>
    <h1>전문가 피드백 제출</h1>
    <%
 		// 로그인 상태 확인
    	session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
        	 // 로그인하지 않은 경우 메시지와 로그인 링크 표시
            out.println("<p>로그인이 필요합니다.</p>");
            %><a href="login.jsp"><button>로그인 화면으로 이동</button></a><%
        } else {
        	// 데이터베이스 연결 및 쿼리 실행 준비
            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            List<String[]> drugList = new ArrayList<>();
            List<String> classList = new ArrayList<>();

            try {
            	// 데이터베이스 연결
                con = Data.getMySQLConnection();
                // 기존 약물 목록 조회
                String drugQuery = "SELECT drug_id, drug_name FROM drug";
                pstmt = con.prepareStatement(drugQuery);
                rs = pstmt.executeQuery();
                while(rs.next()) {
                    drugList.add(new String[]{rs.getString("drug_id"), rs.getString("drug_name")});
                }

                // 약물 분류 목록 조회
                String classQuery = "SELECT class_name FROM drug_classification";
                pstmt = con.prepareStatement(classQuery);
                rs = pstmt.executeQuery();
                while(rs.next()) {
                    classList.add(rs.getString("class_name"));
                }
            } catch(SQLException e) {
            	// SQL 오류 처리
                e.printStackTrace();
            } finally {
            	// 데이터베이스 연결 종료
                Data.close(rs);
                Data.close(pstmt);
                Data.close(con);
            }
            %>
             <!-- 피드백 제출 폼 -->
            <form action="SubmitExpertFeedback.jsp" method="post">
                <label for="drug_id">기존 약물 선택 (수정할 경우):</label><br>
                <select name="drug_id" id="drug_id">
                    <option value="">새로운 약물 추가 또는 선택하지 않음</option>
                    <% for(String[] drug : drugList) { %>
                        <option value="<%= drug[0] %>"><%= drug[1] %></option>
                    <% } %>
                </select><br>

                <label for="new_drug_name">약물 이름:</label><br>
                <input type="text" name="new_drug_name" id="new_drug_name" required><br>

                <label for="drug_class">약물 분류 선택 (또는 새로 입력):</label><br>
                <select name="drug_class_select" id="drug_class_select" onchange="handleClassSelection()">
                    <option value="">분류 선택</option>
                    <% for(String drugClass : classList) { %>
                        <option value="<%= drugClass %>"><%= drugClass %></option>
                    <% } %>
                </select>
                또는 새로운 분류: <input type="text" name="new_drug_class" id="new_drug_class" oninput="handleClassInput()"><br>

                <label for="feedback_content">피드백 내용:</label><br>
                <textarea name="feedback_content" id="feedback_content" rows="4" cols="50" required></textarea><br>

                <input type="submit" value="피드백 제출">
            </form>
            <%
        }
    %>
</body>
</html>
