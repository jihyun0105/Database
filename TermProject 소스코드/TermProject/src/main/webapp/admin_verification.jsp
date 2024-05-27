<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="jsp_test.Data"%> <!-- �����ͺ��̽� ������ ���� ����� ���� Ŭ���� -->
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>������ ����</title>
</head>
<body>
    <h1>������ ����</h1>
    <%
   		 // �޽��� �ʱ�ȭ
        String message = "";
		 // ���� �α��ε� ������� ID Ȯ��
        String loggedInUserId = (session != null) ? (String) session.getAttribute("user_id") : null;

        // �α��ε��� �ʾ��� ��� �α��� �������� ���𷺼�
        if (loggedInUserId == null) {
            response.sendRedirect("login.jsp"); // �α������� ���� ��� �α��� �������� ���𷺼�
            return;
        }
        // POST ��û�� �߻����� �� ������ ����Ű ó��
        if ("POST".equalsIgnoreCase(request.getMethod())) {
        	// ����ڰ� �Է��� ������ ����Ű
            String adminKeyInput = request.getParameter("admin_key");

         // �����ͺ��̽� ���� �� ���� ������ ���� ���� ����
            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
            	// �����ͺ��̽� ���� ����
                con = Data.getMySQLConnection();
                // �α��ε� ������� user_type �� admin_key ��ȸ
                String query = "SELECT user_type, admin_key FROM user WHERE user_id = ?";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, loggedInUserId);
                rs = pstmt.executeQuery();

             // ��� ���� ó��
                if (rs.next()) {
                	// ����� ���� �� �����ͺ��̽��� ����� ������ ����Ű
                    String userType = rs.getString("user_type");
                    String adminKeyFromDB = rs.getString("admin_key");

                 // ������ ���� ���� �� ��ú���� ���𷺼�, ���� �� ���� �޽��� ����
                    if ("administrator".equals(userType) && adminKeyFromDB != null && adminKeyFromDB.equals(adminKeyInput)) {
                        response.sendRedirect("admin_dashboard.jsp");
                    } else {
                        message = "Invalid admin key.";
                    }
                } else {
                    message = "Invalid session.";
                }
            } catch (SQLException e) {
            	 // SQL ���� �� ���� �߻� �� ���� �޽��� ����
                e.printStackTrace();
                message = "An error occurred.";
            } finally {
            	// �����ͺ��̽� ���� ����
                Data.close(rs);
                Data.close(pstmt);
                Data.close(con);
            }
        }
    %>
    <!-- ���� �޽����� ���� ��� ǥ�� -->
    <% if (!message.isEmpty()) { %>
        <p><%= message %></p>
    <% } %>
      <!-- ������ ����Ű �Է� �� -->
    <form action="admin_verification.jsp" method="post">
        ������ ����Ű: <input type="text" name="admin_key" /><br/>
        <input type="submit" value="����" />
    </form>
</body>
</html>
