package com.SQL;

public class User_Bean {
    private int userId;
    private String username;
    private String password;
    private String role;
    private boolean realNameVerified;
    private String createdAt;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isRealNameVerified() { return realNameVerified; }
    public void setRealNameVerified(boolean realNameVerified) { this.realNameVerified = realNameVerified; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
