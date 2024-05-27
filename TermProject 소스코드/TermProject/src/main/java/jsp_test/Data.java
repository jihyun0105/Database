package jsp_test;

//�����ͺ��̽� �۾��� ���� SQL Ŭ�������� ����Ʈ.
import java.sql.Connection; 
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.*;

public class Data {
	// MySQL �����ͺ��̽��� ������ �����ϴ� �޼ҵ�.
	public static Connection getMySQLConnection() {
        Connection conn = null;
        Statement stmt = null;
        PreparedStatement pstmt = null;
        ResultSet result = null;

        try {
            // JDBC ����̹� Ŭ���� �ε� (MariaDB�� ���)
        	// MariaDB�� JDBC ����̹� Ŭ������ �ε�
            Class.forName("org.mariadb.jdbc.Driver");

            // �����ͺ��̽� ���� ���� ����
            String jdbcDriver = "jdbc:mysql://localhost:3306/medicine"; // ������ �����ͺ��̽��� URL
            String dbUser = "root"; // �����ͺ��̽� ����� �̸�
            String dbPass = "jenny1211@@"; // �����ͺ��̽� ��й�ȣ
            String query = "SHOW TABLES;";
            // �����ͺ��̽� ����
            conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
            stmt = conn.createStatement();
        }catch(Exception e) {
        	// ���� ó��
			e.printStackTrace();
		}
		return conn; // ���� ��ü ��ȯ
	}
	// Connection ��ü�� �ݴ� �޼ҵ�
	public static void close(Connection conn) {
		try {if(conn != null) {
			conn.close();
			} 
		} catch(Exception e) {
			e.printStackTrace();
			}
	}
	 // Statement ��ü�� �ݴ� �޼ҵ�
	public static void close(Statement stmt) {
		try {if(stmt != null) {
			stmt.close();
			} 
		} catch(Exception e) {
			e.printStackTrace();
			}
	}
	 // PreparedStatement ��ü�� �ݴ� �޼ҵ�
	public static void close(PreparedStatement pstmt) {
		try {if(pstmt != null) {
			pstmt.close();
			} 
		} catch(Exception e) {
			e.printStackTrace();
			}
	}
	// ResultSet ��ü�� �ݴ� �޼ҵ�
	public static void close(ResultSet rs) {
		try {if(rs != null) {
			rs.close();
			} 
		} catch(Exception e) {
			e.printStackTrace();
			}
	}
}
