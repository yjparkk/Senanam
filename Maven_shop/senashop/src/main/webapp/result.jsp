<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Search Result</title>
</head>
<body>
    <%-- 입력받은 CART_NUM들을 ","로 분리하여 리스트로 저장 --%>
    <%
    String cartNums = request.getParameter("CART_NUMBER");
    String[] cartNumArray = cartNums.split(",");
    List<String> cartNumList = new ArrayList<>();
    for (String cartNum : cartNumArray) {
        cartNumList.add(cartNum.trim());
    }
    %>

    <%-- 데이터베이스 연동하여 검색 결과를 ORDER_PRODUCT 테이블에 삽입 --%>
    <h2>검색 결과:</h2>
    <%
    String jdbcUrl="jdbc:oracle:thin:@aws.c8fgbyyrj5ay.ap-northeast-2.rds.amazonaws.com:1521:orcl";
    String dbUser = "admin";
    String dbPassword = "12345678";

    Connection connection = null;
    PreparedStatement selectStatement = null;
    PreparedStatement insertStatement = null;
    ResultSet resultSet = null;
    
    // 현재 시간 정보를 포함한 문자열 생성
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("YYMMddHHmmssSSS");
    String timestamp = now.format(formatter);
    out.println(timestamp);

    // 고유 번호를 위해 유니크한 식별자 (예: 사용자 아이디, 주문번호 등)와 결합하여 생성
    String uniqueId =  timestamp;
    try {
        connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        connection.setAutoCommit(false); // 트랜잭션 시작

        // CART_NUM 리스트를 이용하여 CART 테이블에서 데이터를 검색
        String selectSql = "SELECT PRODUCT_NUM, PRODUCT_COUNT, PRODUCT_PRICE, ID " +
                           "FROM CART_PRODUCT WHERE CART_NUMBER IN (" + String.join(", ", cartNumList) + ")";
        selectStatement = connection.prepareStatement(selectSql);
        resultSet = selectStatement.executeQuery();

        // ORDER_PRODUCT 테이블에 검색 결과를 삽입
        String insertSql = "INSERT INTO ORDER_PRODUCT (ORDER_NUMBER, PRODUCT_NUM, PRODUCT_COUNT, PRODUCT_PRICE) " +
                           "VALUES (?, ?, ?, ?)";
        insertStatement = connection.prepareStatement(insertSql);

        while (resultSet.next()) {
            String productNum = resultSet.getString("PRODUCT_NUM");
            int productCount = resultSet.getInt("PRODUCT_COUNT");
            int productPrice = resultSet.getInt("PRODUCT_PRICE");
           
           
            String newOrderNumber = uniqueId;
            insertStatement.setString(1, newOrderNumber);
            insertStatement.setString(2, productNum);
            insertStatement.setInt(3, productCount);
            insertStatement.setInt(4, productPrice);
            insertStatement.executeUpdate();
        }
        connection.commit(); // 트랜잭션 커밋
        out.println("데이터가 성공적으로 ORDER_PRODUCT 테이블에 삽입되었습니다.");
    } catch (Exception e) {
        e.printStackTrace();
        connection.rollback(); // 트랜잭션 롤백
        out.println("데이터베이스 연결 또는 쿼리 실행 중 오류가 발생하였습니다.");
    } finally {
        // 리소스 해제
        try { if (resultSet != null) resultSet.close(); } catch (Exception e) { }
        try { if (selectStatement != null) selectStatement.close(); } catch (Exception e) { }
        try { if (insertStatement != null) insertStatement.close(); } catch (Exception e) { }
        try { if (connection != null) connection.close(); } catch (Exception e) { }
    }
    response.sendRedirect("order.jsp?order_num=" + uniqueId);
    %>
    
</body>
</html>
