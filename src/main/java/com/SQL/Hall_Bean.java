package com.SQL;

public class Hall_Bean {
    private int hallId;  // 对应数据库中的 hall_id
    private String hallName;
    private String dynasty;
    private String type;
    private String layoutRules;
    private boolean isOpenBooking;
    private String bookingStartTime;
    private String bookingEndTime;
    private int maxCapacity;

    // Getter 和 Setter 方法
    public int getHallId() {
        return hallId;
    }

    public void setHallId(int hallId) {
        this.hallId = hallId;
    }

    public String getHallName() {
        return hallName;
    }

    public void setHallName(String hallName) {
        this.hallName = hallName;
    }

    public String getDynasty() {
        return dynasty;
    }

    public void setDynasty(String dynasty) {
        this.dynasty = dynasty;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLayoutRules() {
        return layoutRules;
    }

    public void setLayoutRules(String layoutRules) {
        this.layoutRules = layoutRules;
    }

    public boolean isOpenBooking() {
        return isOpenBooking;
    }

    public void setOpenBooking(boolean openBooking) {
        isOpenBooking = openBooking;
    }

    public String getBookingStartTime() {
        return bookingStartTime;
    }

    public void setBookingStartTime(String bookingStartTime) {
        this.bookingStartTime = bookingStartTime;
    }

    public String getBookingEndTime() {
        return bookingEndTime;
    }

    public void setBookingEndTime(String bookingEndTime) {
        this.bookingEndTime = bookingEndTime;
    }

    public int getMaxCapacity() {
        return maxCapacity;
    }

    public void setMaxCapacity(int maxCapacity) {
        this.maxCapacity = maxCapacity;
    }
}