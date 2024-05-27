<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>  <!-- ������ ����: Java ���, HTML ������ Ÿ��, EUC-KR ���ڵ� -->
<%@page import="jsp_test.Data"%>  <!-- �����ͺ��̽� ������ ���� ����� ���� Ŭ���� import -->
<%@page import="java.sql.*"%> <!-- SQL ���� Ŭ���� import -->
<%@page import="java.security.*"%>  <!-- ���� ���� Ŭ���� import -->

<%! 
	//��й�ȣ �ؽ� �Լ�
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
    <title>ȸ������</title>
    <script>
    // ����� ������ ���� �߰����� �ʵ带 ǥ���ϰų� ����� �Լ�
        function toggleUserTypeFields() {
            var userType = document.querySelector('select[name="user_type"]').value;
            // �ʿ��� ���, ����� ������ ���� �߰����� �ʵ� ǥ��/�����
        }
    </script>
</head>
<body>
    <h1>ȸ������</h1>
    <%
        String message = "";
        boolean isSubmitted = false;
        String userType = "";
     	// POST ��û ó��
        if ("POST".equalsIgnoreCase(request.getMethod())) {
        	// �� �Է� �� ��������
            String user_id = request.getParameter("user_id");
            String user_password = request.getParameter("user_password");
            String email = request.getParameter("email");
            String phone_number = request.getParameter("phone_number");
            userType = request.getParameter("user_type");
            Connection con = null;
            PreparedStatement pstmt = null;
            try {
            	// �����ͺ��̽� ����
                con = Data.getMySQLConnection();
             // ��й�ȣ �ؽ�
                String hashedPassword = hashPassword(user_password);
             // ����� �߰� ���� ����
                String query = "INSERT INTO User (user_id, user_password, email, phone_number, user_type, registration_date) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, user_id);
                pstmt.setString(2, hashedPassword);
                pstmt.setString(3, email);
                pstmt.setString(4, phone_number);
                pstmt.setString(5, userType);
                int result = pstmt.executeUpdate();
                // ��� ó��
                if(result > 0) {
                    message = "ȸ�������� �Ϸ�Ǿ����ϴ�.";
                    session = request.getSession();
                    session.setAttribute("user_id", user_id); 
                } else {
                    message = "ȸ������ ����.";
                }
                isSubmitted = true;
            } catch (Exception e) {
                e.printStackTrace();
                message = "������ �߻��߽��ϴ�: " + e.getMessage();
            } finally {
            	// �ڿ� ����
                Data.close(pstmt);
                Data.close(con);
            }
        }
     // ���� ������� ���� ���, ȸ������ �� ǥ��
        if (!isSubmitted) {
    %>
            <form action="signup.jsp" method="post">
                ���̵�: <input type="text" name="user_id" /><br/>
                ��й�ȣ: <input type="password" name="user_password" /><br/>
                �̸���: <input type="email" name="email" /><br/>
                ��ȭ��ȣ: <input type="text" name="phone_number" /><br/>
                ����� ����:
                <select name="user_type" onchange="toggleUserTypeFields()">
                    <option value="expert">������</option>
                    <option value="user">�Ϲ� �����</option>
                </select><br/>
                <input type="submit" value="ȸ������" />
            </form>
    <%
        }else {
        	 // �� ���� �� ��� �޽��� �� �߰� ��ư ǥ��
            out.print("<p>" + message + "</p>");
            out.print("<button onclick=\"location.href='MedicineSearch.jsp'\">����</button>");
         // ������ �� ���, ������ ���� ��ư ǥ��
            if ("expert".equals(userType)) {  // �������� ���
                out.print("<button onclick=\"location.href='expert_verification.jsp'\">������ ����</button>");
            } 
        }
    %>
     <button onclick="location.href='MedicineSearch.jsp'">����</button>  <!-- '����' ��ư �߰� -->
</body>
</body>
</html>
