<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE HTML>
<!--
    Binary by TEMPLATED
    templated.co @templatedco
    Released for free under the Creative Commons Attribution 3.0 license (templated.co/license)
-->
<html>
<head>
    <title>세나샵</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="assets/css/main.css" />
</head>
<body>

    <!-- Header -->
    <header id="header">
        <a href="index.html" class="logo"><strong>세 나</strong> shop</a>
        <nav>
            <a href="#menu">Menu</a>
        </nav>
    </header>

    <!-- Nav -->
    <nav id="menu">
        <ul class="links">
            <li><a href="index.html">Home</a></li>
            <li><a href="generic.html">Generic</a></li>
            <li><a href="elements.html">Elements</a></li>
        </ul>
    </nav>

    <!-- 기능구현 -->
    <section>
        <div style="padding: 80px;">
            <h1>결제</h1>
           

            <h3>상품</h3>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>주문번호</th>
                            <th>상품ID</th>
                            <th>상품수량</th>
                            <th>상품가격</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%@ page import="java.sql.*" %>
                        <%!
                            // 데이터베이스 접속 정보 설정
                            String dbUrl = "jdbc:oracle:thin:@localhost:1521:xe"; // 오라클 서버 주소와 포트번호
                            String dbUser = "C##junho"; // 오라클 계정 사용자명
                            String dbPassword = "1234"; // 오라클 계정 비밀번호
                            String odn;
                            int tp;
                        %>
                        <% 
                            Connection conn = null;
                            PreparedStatement pstmt = null;
                            ResultSet rs = null;

                            try {
                                // 오라클 JDBC 드라이버 로딩
                                Class.forName("oracle.jdbc.driver.OracleDriver");

                                // 데이터베이스에 접속
                                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                                String orderNumberParam = request.getParameter("order_number");
                                String sqlQuery;
                                if (orderNumberParam != null && !orderNumberParam.isEmpty()) {
                                    // 주문번호 파라미터가 있을 경우 해당 주문번호로 검색
                                    odn = orderNumberParam;
                                    sqlQuery = "SELECT * FROM order_product WHERE order_num = ?";
                                    pstmt = conn.prepareStatement(sqlQuery);
                                    pstmt.setString(1, orderNumberParam);
                                } else {
                                    // 주문번호 파라미터가 없을 경우 모든 데이터 조회
                                    sqlQuery = "SELECT * FROM order_product";
                                    pstmt = conn.prepareStatement(sqlQuery);
                                }
                                rs = pstmt.executeQuery();

                                int totalPrice = 0; // 총 가격을 저장할 변수
                                // 결과 처리
                                while (rs.next()) {
                                    out.println("<tr>");
                                    out.println("<td>" + rs.getString("order_num") + "</td>");
                                    out.println("<td>" + rs.getString("PID") + "</td>");
                                    out.println("<td>" + rs.getString("PROD_CNT") + "</td>");
                                    out.println("<td>" + rs.getString("PROD_PRICE") + "</td>");
                                    out.println("</tr>");
                                    // 상품 수량과 가격을 곱해서 총 가격 계산
                                    int prodCnt = rs.getInt("PROD_CNT");
                                    int prodPrice = rs.getInt("PROD_PRICE");
                                    totalPrice += prodCnt * prodPrice;
                                }
                                // 총 가격 출력
                                out.println("<tr>");
                                out.println("<td colspan='4' align='right'>총 가격: " + totalPrice + "원</td>");
                                out.println("</tr>");
                                tp = totalPrice;

                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                // 리소스 해제
                                try {
                                    if (rs != null) rs.close();
                                    if (pstmt != null) pstmt.close();
                                    if (conn != null) conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            }
                            
                        %>
                    </tbody>
                </table>
            </div>




            <h3>배송지</h3>
            <form action="addorderlist.jsp" method="get">
                
            <input type="hidden" name="total_price" value="<%=tp%>">
            <input type="hidden" name="order_number" value="<%=odn%>">
                우편번호<input type="text" name="zipcode"><br/>
                배달지<input type="text" name="address"><br/>
                <div align="right">
                    <input type="submit" value="결제">
                </div>
            </form>
        </div>
    </section>

    <!-- Footer -->
    <footer id="footer">
        <div class="copyright">
            Made with team 세나남</a>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/jquery.scrolly.min.js"></script>
   
