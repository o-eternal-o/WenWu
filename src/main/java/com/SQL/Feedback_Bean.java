package com.SQL;

public class Feedback_Bean {
    private int feedbackId;
    private int userId;
    private Integer relicId;
    private String content;
    private String status;
    private String resolvedResult;
    private String createdAt;

    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getRelicId() { return relicId; }
    public void setRelicId(Integer relicId) { this.relicId = relicId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getResolvedResult() { return resolvedResult; }
    public void setResolvedResult(String resolvedResult) { this.resolvedResult = resolvedResult; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}