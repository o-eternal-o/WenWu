```mysql
-- 建立数据库
CREATE DATABASE cultural_exhibition_db
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE cultural_exhibition_db;
    
-- 用户信息表（存储系统用户的基本信息）
CREATE TABLE user (
  user_id INT AUTO_INCREMENT PRIMARY KEY,          -- 用户唯一标识
  username VARCHAR(50) UNIQUE NOT NULL,            -- 登录用户名
  password VARCHAR(255) NOT NULL,                  -- 密码
  phone VARCHAR(20),                               -- 联系电话
  role ENUM('admin', 'visitor') NOT NULL DEFAULT 'visitor', -- 用户角色：admin-管理员, visitor-游客
  real_name VARCHAR(100),                          -- 真实姓名
  real_name_verified BOOLEAN DEFAULT FALSE,        -- 是否通过实名认证
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP   -- 账户创建时间
) ENGINE=InnoDB COMMENT='系统用户信息表';

-- 展厅信息表（记录展厅配置信息）
CREATE TABLE exhibition_hall (
  hall_id INT AUTO_INCREMENT PRIMARY KEY,               -- 展厅唯一标识
  hall_name VARCHAR(100) NOT NULL,                      -- 展厅名称
  dynasty VARCHAR(50),                                  -- 所属朝代分类
  type VARCHAR(50),                                     -- 文物类型分类
  layout_rules TEXT,                                    -- 展厅布局规则描述
  is_open_booking BOOLEAN DEFAULT TRUE,                -- 是否开放预约
  booking_start_time TIME,                              -- 每日预约开始时间
  booking_end_time TIME,                                -- 每日预约结束时间
  max_capacity INT DEFAULT 100                         -- 展厅最大承载人数
) ENGINE=InnoDB COMMENT='文物展厅配置表';

-- 文物信息表（文物详细信息记录）
CREATE TABLE cultural_relic (
  relic_id INT AUTO_INCREMENT PRIMARY KEY,             -- 文物唯一标识
  relic_name VARCHAR(100) NOT NULL,                    -- 文物名称
  dynasty VARCHAR(50) NOT NULL,                        -- 所属朝代
  description TEXT,                                    -- 文物详细描述
  hall_id INT NOT NULL,                                -- 所属展厅ID
  image_path VARCHAR(255),                             -- 文物图片存储路径
  created_by INT,                                      -- 创建人（管理员用户ID）
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- 信息创建时间
  FOREIGN KEY (hall_id) REFERENCES exhibition_hall(hall_id),
  FOREIGN KEY (created_by) REFERENCES user(user_id)
) ENGINE=InnoDB COMMENT='文物基本信息表';

-- 新闻资讯表（存储文物相关新闻）
CREATE TABLE news (
  news_id INT AUTO_INCREMENT PRIMARY KEY,             -- 新闻唯一标识
  title VARCHAR(200) NOT NULL,                        -- 新闻标题
  content TEXT NOT NULL,                              -- 新闻正文内容
  publish_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- 发布时间
  publisher_id INT NOT NULL,                          -- 发布者用户ID
  FOREIGN KEY (publisher_id) REFERENCES user(user_id)
) ENGINE=InnoDB COMMENT='新闻资讯发布表';

-- 预约记录表（游客预约信息管理）
CREATE TABLE booking (
  booking_id INT AUTO_INCREMENT PRIMARY KEY,          -- 预约记录唯一标识
  user_id INT NOT NULL,                               -- 预约用户ID
  hall_id INT NOT NULL,                               -- 预约展厅ID
  booking_time DATETIME NOT NULL,                    -- 预约参观时间
  status ENUM('pending', 'confirmed', 'canceled') DEFAULT 'pending', -- 预约状态
  is_group BOOLEAN DEFAULT FALSE,                    -- 是否为团队预约
  group_size INT,                                    -- 团队人数（仅团队预约有效）
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- 预约创建时间
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (hall_id) REFERENCES exhibition_hall(hall_id)
) ENGINE=InnoDB COMMENT='参观预约记录表';

-- 用户反馈表（文物信息错误反馈）
CREATE TABLE feedback (
  feedback_id INT AUTO_INCREMENT PRIMARY KEY,        -- 反馈记录唯一标识
  user_id INT NOT NULL,                              -- 提交用户ID
  relic_id INT,                                      -- 关联文物ID（可选）
  content TEXT NOT NULL,                             -- 反馈内容
  status ENUM('submitted', 'processing', 'resolved') DEFAULT 'submitted', -- 处理状态
  resolved_result TEXT,                              -- 处理结果描述
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- 反馈提交时间
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (relic_id) REFERENCES cultural_relic(relic_id)
) ENGINE=InnoDB COMMENT='用户反馈处理表';


-- 插入用户信息表测试数据
INSERT INTO user (username, password, phone, role, real_name, real_name_verified, created_at) VALUES
('admin1', '123456', '1234567890', 'admin', 'Admin1', TRUE, NOW()),
('admin2', '123456', '1234567891', 'admin', 'Admin2', TRUE, NOW()),
('张三', '654321', '1234567892', 'visitor', '张三', FALSE, NOW()),
('李四', '654321', '1234567893', 'visitor', '李四', TRUE, NOW()),
('王二', '654321', '1234567894', 'visitor', '王二', FALSE, NOW()),
('麻子', '654321', '1234567895', 'visitor', '麻子', TRUE, NOW()),
('虎子', '654321', '1234567896', 'visitor', '虎子', FALSE, NOW());

-- 插入展厅信息表测试数据
INSERT INTO exhibition_hall (hall_name, dynasty, type, layout_rules, is_open_booking, booking_start_time, booking_end_time, max_capacity) VALUES
('Hall-1', '唐', 'book', 'Rule1', TRUE, '09:00:00', '17:00:00', 110),
('Hall-2', '宋', 'book', 'Rule2', TRUE, '09:00:00', '17:00:00', 70),
('Hall-3', '元', 'book', 'Rule3', TRUE, '09:00:00', '17:00:00', 130),
('Hall-4', '明', 'book', 'Rule4', TRUE, '09:00:00', '17:00:00', 140),
('Hall-5', '清', 'Books', 'Rule5', TRUE, '09:00:00', '17:00:00', 160);

-- 插入文物信息表测试数据
INSERT INTO cultural_relic (relic_name, dynasty, description, hall_id, image_path, created_by, created_at) VALUES
('Relic 1', '唐', '唐代书籍文物描述', 1, '/images/relic1.jpg', 1, NOW()),
('Relic 2', '宋', '宋代书籍文物描述', 2, '/images/relic2.jpg', 1, NOW()),
('Relic 3', '元', '元代书籍文物描述', 3, '/images/relic3.jpg', 2, NOW()),
('Relic 4', '明', '明代书籍文物描述', 4, '/images/relic4.jpg', 2, NOW()),
('Relic 5', '清', '清代书籍文物描述', 5, '/images/relic5.jpg', 3, NOW());

-- 插入新闻资讯表测试数据
INSERT INTO news (title, content, publish_time, publisher_id) VALUES
('News One', 'Content 1', NOW(), 1),
('News Two', 'Content 2', NOW(), 1),
('News Three', 'Content 3', NOW(), 2);

-- 插入预约记录表测试数据
INSERT INTO booking (user_id, hall_id, booking_time, status, is_group, group_size, created_at) VALUES
(3, 1, '2025-05-16 10:00:00', 'pending', FALSE, NULL, NOW()),
(4, 2, '2025-05-16 11:00:00', 'confirmed', TRUE, 10, NOW());

-- 插入用户反馈表测试数据
INSERT INTO feedback (user_id, relic_id, content, status, resolved_result, created_at) VALUES
(1, 1, 'Feedback 1', 'submitted', NULL, NOW());


-- 删除用户反馈表
DROP TABLE IF EXISTS feedback;

-- 删除预约记录表
DROP TABLE IF EXISTS booking;

-- 删除新闻资讯表
DROP TABLE IF EXISTS news;

-- 删除文物信息表
DROP TABLE IF EXISTS cultural_relic;

-- 删除展厅信息表
DROP TABLE IF EXISTS exhibition_hall;

-- 删除用户信息表
DROP TABLE IF EXISTS user;
```