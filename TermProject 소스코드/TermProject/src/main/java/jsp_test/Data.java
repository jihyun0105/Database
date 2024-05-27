package jsp_test;

//데이터베이스 작업을 위한 SQL 클래스들을 임포트.
import java.sql.Connection; 
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.*;

public class Data {
	// MySQL 데이터베이스에 연결을 설정하는 메소드.
	public static Connection getMySQLConnection() {
        Connection conn = null;
        Statement stmt = null;
        PreparedStatement pstmt = null;
        ResultSet result = null;

        try {
            // JDBC 드라이버 클래스 로드 (MariaDB의 경우)
        	// MariaDB용 JDBC 드라이버 클래스를 로드
            Class.forName("org.mariadb.jdbc.Driver");

            // 데이터베이스 접속 정보 설정
            String jdbcDriver = "jdbc:mysql://localhost:3306/medicine"; // 접속할 데이터베이스의 URL
            String dbUser = "root"; // 데이터베이스 사용자 이름
            String dbPass = "jenny1211@@"; // 데이터베이스 비밀번호
            String query = "SHOW TABLES;";
            // 데이터베이스 연결
            conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
            stmt = conn.createStatement();
        }catch(Exception e) {
        	// 예외 처리
			e.printStackTrace();
		}
		return conn; // 연결 객체 반환
	}
	// Connection 객체를 닫는 메소드
	public static void close(Connection conn) {
		try {if(conn != null) {
			conn.close();
			} 
		} catch(Exception e) {
			e.printStackTrace();
			}
	}
	 // Statement 객체를 닫는 메소드
	public static void close(Statement stmt) {
		try {if(stmt != null) {
			stmt.close();
			} 
		} catch(Exception e) {
			e.printStackTrace();
			}
	}
	 // PreparedStatement 객체를 닫는 메소드
	public static void close(PreparedStatement pstmt) {
		try {if(pstmt != null) {
			pstmt.close();
			} 
		} catch(Exception e) {
			e.printStackTrace();
			}
	}
	// ResultSet 객체를 닫는 메소드
	public static void close(ResultSet rs) {
		try {if(rs != null) {
			rs.close();
			} 
		} catch(Exception e) {
			e.printStackTrace();
			}
	}
}
