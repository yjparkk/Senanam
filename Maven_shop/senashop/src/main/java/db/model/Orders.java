package db.model;

import java.sql.Date;

public class Orders {
    private long orderNumber;
    private String id;
    private int totalPrice;
    private int orderCheck;
    private String address;
    private String zipcode;

    public Orders(long orderNumber, String id, int totalPrice, int orderCheck, String address, String zipcode) {
        super();
        this.orderNumber = orderNumber;
        this.id = id;
        this.totalPrice = totalPrice;
        this.orderCheck = orderCheck;
        this.address = address;
        this.zipcode = zipcode;
    }

    public long getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(long orderNumber) {
        this.orderNumber = orderNumber;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getOrderCheck() {
        return orderCheck;
    }

    public void setOrderCheck(int orderCheck) {
        this.orderCheck = orderCheck;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

}
