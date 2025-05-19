package com.admin;

public class Hall {
    private int hallId;
    private String hallName;
    private String location;
    private String description;

    // 默认构造方法
    public Hall() {}

    // 带参数的构造方法
    public Hall(int hallId, String hallName, String location, String description) {
        this.hallId = hallId;
        this.hallName = hallName;
        this.location = location;
        this.description = description;
    }

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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
