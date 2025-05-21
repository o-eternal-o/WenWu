package com.DAO;

import com.SQL.DatabaseConnector;
import com.SQL.News_Bean;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class NewsDAO {
    private DatabaseConnector dbConnector = new DatabaseConnector();

    public List<News_Bean> listNews() throws Exception {
        List<News_Bean> newsList = new ArrayList<>();
        String query = "SELECT * FROM news";
        ResultSet rs = dbConnector.executeQuery(query);
        while (rs.next()) {
            News_Bean news = new News_Bean();
            news.setNewsId(rs.getInt("news_id"));
            news.setTitle(rs.getString("title"));
            news.setContent(rs.getString("content"));
            news.setPublishTime(rs.getString("publish_time"));
            news.setPublisherId(rs.getInt("publisher_id"));
            newsList.add(news);
        }
        return newsList;
    }

    public List<News_Bean> searchNews(String searchType, String searchInput) throws Exception {
        List<News_Bean> newsList = new ArrayList<>();
        String query = "SELECT * FROM news WHERE " + searchType + " LIKE ?";
        String param = "%" + searchInput + "%";
        ResultSet rs = dbConnector.executeQuery(query, param);
        while (rs.next()) {
            News_Bean news = new News_Bean();
            news.setNewsId(rs.getInt("news_id"));
            news.setTitle(rs.getString("title"));
            news.setContent(rs.getString("content"));
            news.setPublishTime(rs.getString("publish_time"));
            news.setPublisherId(rs.getInt("publisher_id"));
            newsList.add(news);
        }
        return newsList;
    }

    public void addNews(News_Bean news) throws Exception {
        String query = "INSERT INTO news (title, content, publish_time, publisher_id) VALUES (?, ?, ?, ?)";
        dbConnector.executeUpdate(query,
                news.getTitle(),
                news.getContent(),
                news.getPublishTime(),
                news.getPublisherId());
    }

    public News_Bean getNewsById(int newsId) throws Exception {
        String query = "SELECT * FROM news WHERE news_id = ?";
        ResultSet rs = dbConnector.executeQuery(query, newsId);
        if (rs.next()) {
            News_Bean news = new News_Bean();
            news.setNewsId(rs.getInt("news_id"));
            news.setTitle(rs.getString("title"));
            news.setContent(rs.getString("content"));
            news.setPublishTime(rs.getString("publish_time"));
            news.setPublisherId(rs.getInt("publisher_id"));
            return news;
        }
        return null;
    }

    public void updateNews(News_Bean news) throws Exception {
        String query = "UPDATE news SET title = ?, content = ?, publish_time = ?, publisher_id = ? WHERE news_id = ?";
        dbConnector.executeUpdate(query,
                news.getTitle(),
                news.getContent(),
                news.getPublishTime(),
                news.getPublisherId(),
                news.getNewsId());
    }

    public void deleteNews(int newsId) throws Exception {
        String query = "DELETE FROM news WHERE news_id = ?";
        dbConnector.executeUpdate(query, newsId);
    }
}