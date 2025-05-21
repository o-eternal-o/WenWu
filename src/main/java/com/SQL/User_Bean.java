package com.SQL;

public class User_Bean {
    private int userId;
    private String username;
    private String password;
    private String phone;
    private String role;
    private String realName;
    private boolean realNameVerified;
    private String createdAt;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getRealName() { return realName; }
    public void setRealName(String realName) { this.realName = realName; }

    public boolean isRealNameVerified() { return realNameVerified; }
    public void setRealNameVerified(boolean realNameVerified) { this.realNameVerified = realNameVerified; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
