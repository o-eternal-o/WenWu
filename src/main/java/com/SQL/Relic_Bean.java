package com.SQL;

public class Relic_Bean {
    private int relicId;
    private String relicName;
    private String dynasty;
    private String description;
    private int hallId;
    private String imagePath;
    private Integer createdBy;
    private String createdAt;

    public int getRelicId() {
        return relicId;
    }

    public void setRelicId(int relicId) {
        this.relicId = relicId;
    }

    public String getRelicName() {
        return relicName;
    }

    public void setRelicName(String relicName) {
        this.relicName = relicName;
    }

    public String getDynasty() {
        return dynasty;
    }

    public void setDynasty(String dynasty) {
        this.dynasty = dynasty;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getHallId() {
        return hallId;
    }

    public void setHallId(int hallId) {
        this.hallId = hallId;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}