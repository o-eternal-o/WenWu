package com.DAO;

import com.SQL.DatabaseConnector;
import com.SQL.Relic_Bean;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RelicDAO {

    private DatabaseConnector dbConnector = new DatabaseConnector();

    // 查询所有文物
    public List<Relic_Bean> listRelics() throws Exception {
        List<Relic_Bean> relics = new ArrayList<>();
        String query = "SELECT * FROM cultural_relic";
        ResultSet rs = dbConnector.executeQuery(query);
        while (rs.next()) {
            Relic_Bean relic = new Relic_Bean();
            relic.setRelicId(rs.getInt("relic_id"));
            relic.setRelicName(rs.getString("relic_name"));
            relic.setDynasty(rs.getString("dynasty"));
            relic.setDescription(rs.getString("description"));
            relic.setHallId(rs.getInt("hall_id"));
            relic.setImagePath(rs.getString("image_path"));
            relic.setCreatedBy((Integer)rs.getObject("created_by"));
            relic.setCreatedAt(rs.getString("created_at"));
            relics.add(relic);
        }
        return relics;
    }

    // 按条件查询文物
    public List<Relic_Bean> searchRelics(String searchType, String searchInput) throws Exception {
        List<Relic_Bean> relics = new ArrayList<>();
        String query = "SELECT * FROM cultural_relic WHERE " + searchType + " LIKE ?";
        String param = "%" + searchInput + "%";
        ResultSet rs = dbConnector.executeQuery(query, param);
        while (rs.next()) {
            Relic_Bean relic = new Relic_Bean();
            relic.setRelicId(rs.getInt("relic_id"));
            relic.setRelicName(rs.getString("relic_name"));
            relic.setDynasty(rs.getString("dynasty"));
            relic.setDescription(rs.getString("description"));
            relic.setHallId(rs.getInt("hall_id"));
            relic.setImagePath(rs.getString("image_path"));
            relic.setCreatedBy((Integer)rs.getObject("created_by"));
            relic.setCreatedAt(rs.getString("created_at"));
            relics.add(relic);
        }
        return relics;
    }

    // 添加文物
    public void addRelic(Relic_Bean relic) throws Exception {
        String query = "INSERT INTO cultural_relic (relic_name, dynasty, description, hall_id, image_path, created_by, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        dbConnector.executeUpdate(query,
                relic.getRelicName(),
                relic.getDynasty(),
                relic.getDescription(),
                relic.getHallId(),
                relic.getImagePath(),
                relic.getCreatedBy(),
                relic.getCreatedAt());
    }

    // 获取单个文物
    public Relic_Bean getRelicById(int relicId) throws Exception {
        String query = "SELECT * FROM cultural_relic WHERE relic_id = ?";
        ResultSet rs = dbConnector.executeQuery(query, relicId);
        if (rs.next()) {
            Relic_Bean relic = new Relic_Bean();
            relic.setRelicId(rs.getInt("relic_id"));
            relic.setRelicName(rs.getString("relic_name"));
            relic.setDynasty(rs.getString("dynasty"));
            relic.setDescription(rs.getString("description"));
            relic.setHallId(rs.getInt("hall_id"));
            relic.setImagePath(rs.getString("image_path"));
            relic.setCreatedBy((Integer)rs.getObject("created_by"));
            relic.setCreatedAt(rs.getString("created_at"));
            return relic;
        }
        return null;
    }

    // 修改文物
    public void updateRelic(Relic_Bean relic) throws Exception {
        String query = "UPDATE cultural_relic SET relic_name = ?, dynasty = ?, description = ?, hall_id = ?, image_path = ?, created_by = ?, created_at = ? WHERE relic_id = ?";
        dbConnector.executeUpdate(query,
                relic.getRelicName(),
                relic.getDynasty(),
                relic.getDescription(),
                relic.getHallId(),
                relic.getImagePath(),
                relic.getCreatedBy(),
                relic.getCreatedAt(),
                relic.getRelicId());
    }

    // 删除文物
    public void deleteRelic(int relicId) throws Exception {
        String query = "DELETE FROM cultural_relic WHERE relic_id = ?";
        dbConnector.executeUpdate(query, relicId);
    }
}