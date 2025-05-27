```mysql
-- 用户信息表（存储系统用户的基本信息）
CREATE TABLE user (
  user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户唯一标识',
  username VARCHAR(50) UNIQUE NOT NULL COMMENT '登录用户名',
  password VARCHAR(255) NOT NULL COMMENT '密码',
  role ENUM('admin', 'visitor') NOT NULL DEFAULT 'visitor' COMMENT '用户角色：admin-管理员, visitor-游客',
  real_name_verified BOOLEAN DEFAULT FALSE COMMENT '是否通过实名认证',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '账户创建时间'
) ENGINE=InnoDB COMMENT='系统用户信息表';

-- 展厅信息表（记录展厅配置信息）
CREATE TABLE halls (
  hall_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '展厅唯一标识',
  hall_name VARCHAR(100) NOT NULL COMMENT '展厅名称',
  dynasty VARCHAR(50) COMMENT '所属朝代分类',
  type VARCHAR(50) COMMENT '文物类型分类',
  layout_rules TEXT COMMENT '展厅布局规则描述',
  is_open_booking BOOLEAN DEFAULT TRUE COMMENT '是否开放预约',
  booking_start_time TIME COMMENT '每日预约开始时间',
  booking_end_time TIME COMMENT '每日预约结束时间',
  max_capacity INT DEFAULT 100 COMMENT '展厅最大承载人数'
) ENGINE=InnoDB COMMENT='文物展厅配置表';

-- 文物信息表（文物详细信息记录）
CREATE TABLE cultural_relic (
  relic_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '文物唯一标识',
  relic_name VARCHAR(100) NOT NULL COMMENT '文物名称',
  dynasty VARCHAR(50) NOT NULL COMMENT '所属朝代',
  description TEXT COMMENT '文物详细描述',
  hall_id INT NOT NULL COMMENT '所属展厅ID',
  image_path VARCHAR(255) COMMENT '文物图片存储路径',
  created_by INT COMMENT '创建人（管理员用户ID）',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '信息创建时间',
  FOREIGN KEY (hall_id) REFERENCES halls(hall_id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES user(user_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='文物基本信息表';

-- 新闻资讯表（存储文物相关新闻）
CREATE TABLE news (
  news_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '新闻唯一标识',
  title VARCHAR(200) NOT NULL COMMENT '新闻标题',
  content TEXT NOT NULL COMMENT '新闻正文内容',
  publish_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  publisher_id INT NOT NULL COMMENT '发布者用户ID',
  FOREIGN KEY (publisher_id) REFERENCES user(user_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='新闻资讯发布表';

-- 预约记录表（游客预约信息管理）
CREATE TABLE booking (
  booking_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '预约记录唯一标识',
  user_id INT NOT NULL COMMENT '预约用户ID',
  hall_id INT NOT NULL COMMENT '预约展厅ID',
  booking_time DATETIME NOT NULL COMMENT '预约参观时间',
  status ENUM('pending', 'confirmed', 'canceled') DEFAULT 'pending' COMMENT '预约状态',
  is_group BOOLEAN DEFAULT FALSE COMMENT '是否为团队预约',
  group_size INT COMMENT '团队人数（仅团队预约有效）',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '预约创建时间',
  FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
  FOREIGN KEY (hall_id) REFERENCES halls(hall_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='参观预约记录表';

-- 用户反馈表（文物信息错误反馈）
CREATE TABLE feedback (
  feedback_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '反馈记录唯一标识',
  user_id INT NOT NULL COMMENT '提交用户ID',
  relic_id INT COMMENT '关联文物ID（可选）',
  content TEXT NOT NULL COMMENT '反馈内容',
  status ENUM('submitted', 'processing', 'resolved') DEFAULT 'submitted' COMMENT '处理状态',
  resolved_result TEXT COMMENT '处理结果描述',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '反馈提交时间',
  FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
  FOREIGN KEY (relic_id) REFERENCES cultural_relic(relic_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='用户反馈处理表';

-- 实名认证表（存储用户实名认证信息）
CREATE TABLE user_verification (
  verification_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '认证ID',
  user_id INT NOT NULL COMMENT '用户ID',
  real_name VARCHAR(100) NOT NULL COMMENT '真实姓名',
  phone VARCHAR(20) NOT NULL COMMENT '联系电话',
  id_number VARCHAR(100) NOT NULL COMMENT '身份证号',
  id_image_path VARCHAR(255) COMMENT '证件图片存储路径',
  status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING' COMMENT '认证状态',
  reject_reason TEXT COMMENT '拒绝原因',
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  reviewed_at TIMESTAMP NULL COMMENT '审核时间',
  reviewed_by INT NULL COMMENT '审核人ID',
  FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
  FOREIGN KEY (reviewed_by) REFERENCES user(user_id) ON DELETE SET NULL,
  UNIQUE INDEX idx_id_number (id_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户实名认证表';

-- 创建触发器：在实名认证表插入或更新数据后，更新用户表的实名认证状态
DELIMITER //
CREATE TRIGGER after_user_verification_insert_update
AFTER INSERT ON user_verification
FOR EACH ROW
BEGIN
  -- 如果认证状态为 APPROVED，则将用户表中的 real_name_verified 设置为 TRUE
  IF NEW.status = 'APPROVED' THEN
    UPDATE user
    SET real_name_verified = TRUE
    WHERE user_id = NEW.user_id;
  -- 如果认证状态为 REJECTED 或 PENDING，则将用户表中的 real_name_verified 设置为 FALSE
  ELSE
    UPDATE user
    SET real_name_verified = FALSE
    WHERE user_id = NEW.user_id;
  END IF;
END;
//
DELIMITER ;



-- 插入用户信息表测试数据
INSERT INTO user (username, password, role, real_name_verified, created_at) VALUES
('admin', '123456', 'admin', FALSE, NOW()),
('admin1', '123456', 'admin', FALSE, NOW()),
('张三', '654321', 'visitor', TRUE, NOW()),
('李四', '654321', 'visitor', TRUE, NOW()),
('王五', '654321', 'visitor', FALSE, NOW()),
('赵六', '654321', 'visitor', FALSE, NOW());

-- 插入展厅信息表测试数据
INSERT INTO halls (hall_name, dynasty, type, layout_rules, is_open_booking, booking_start_time, booking_end_time, max_capacity) VALUES
('Hall-1', '唐', 'book', 'Rule1', TRUE, '09:00:00', '17:00:00', 110),
('Hall-2', '宋', 'book', 'Rule2', FALSE, '09:00:00', '17:00:00', 70),
('Hall-3', '元', 'book', 'Rule3', FALSE, '09:00:00', '17:00:00', 130),
('Hall-4', '明', 'book', 'Rule4', TRUE, '09:00:00', '17:00:00', 140),
('Hall-5', '清', 'Books', 'Rule5', TRUE, '09:00:00', '17:00:00', 160);

-- 插入文物信息表测试数据

-- 唐代文物
INSERT INTO cultural_relic (relic_name, dynasty, description, hall_id, image_path, created_by, created_at) VALUES
('黑釉狗', '唐', '小狗半施黑釉，昂首直立，双眼圆睁，身上毛发雕刻清晰。唐代瓷塑作品以动物和人俑居多，这件唐代黑釉狗耸鬃卷尾，表达出鲜明的力度和传神的意趣。', 1, '/WenWu_Web_exploded/assets/Tang/ceram/10001.jpg', 1, NOW()),
('红陶骑马狩猎俑', '唐', '猎者留八字胡须，头戴幞头，身穿翻领大衣，骑于马上左右巡视，猎狗端坐猎者身后，神情闲散。主人的紧张与小狗的松弛形成鲜明对照。唐朝统治者有北方少数民族血统，性喜狩猎，并以善猎为荣，灿烂多彩的狩猎俑正是这一文化背景的缩影。', 1, '/WenWu_Web_exploded/assets/Tang/ceram/10002.jpg', 1, NOW()),
('三彩骑马狩猎俑', '唐', '马身直立，微向前倾，作欲发之势。骑马者高鼻深目，络腮胡，八字须，头罩黑色幞头，身着绿色翻领窄袖袍，足登乌皮靴，双手持缰，凝视前方，身后蹲坐一犬。苏轼《江城子》描述的："老夫聊发少年狂，左牵黄，右擎苍。锦帽貂裘，千骑卷平冈。"胡服骑射，左手牵黄狗，右臂架苍鹰，这一形象广泛地出现在艺术作品中。唐代狩猎俑生动地体现了北方民族狩猎的习俗。更重要的是其所塑造的狩猎犬中有的甚至是西域等地进献的礼品，表现了大唐帝国与外邦的友好往来。', 1, '/WenWu_Web_exploded/assets/Tang/ceram/10003.jpg', 1, NOW()),
('白釉兔系罐', '唐', '罐撇口、短颈，丰肩、圆腹。通体施白釉，近底足处素面无釉。肩部置兔形双系，可穿绳索以便提携。唐代白瓷生产在中国北方发展迅速，与南方的青瓷生产遥相呼应，形成"南青北白"的局面。此件器物以兔的形像做双系装饰，不事张扬，又令整个器形顿显生动，于平淡中见巧思，可谓匠心独运。', 1, '/WenWu_Web_exploded/assets/Tang/ceram/10004.jpg', 1, NOW()),
('阎立本步辇图卷', '唐', '这是一幅历史画。它反映唐代初年一个重大的历史事件。公元七世纪，地处我国西南的吐蕃（今西藏地区）开始强大兴盛，其三十二世赞普松赞干布是个"骁勇多英略"的领袖。贞观八年（634年），他遣使臣到长安（今陕西西安），向唐王朝求婚联姻，唐太宗李世民答应了他的请求，决定将宗室女文成公主许配给松赞干布。贞观十五年（641年）春天，松赞干布派相国禄东赞到长安来迎接文成公主，唐太宗李世民则派礼部尚书江夏王宗室李道宗陪同文成公主进吐蕃。文成公主除了带去很多中原地区的文化典籍外，随行的还有许多各种行业的工匠，对于促进吐蕃经济、文化的发展起到了重要的作用。此后很长一段时间里，唐王朝和吐蕃之间关系融洽，和睦相处。阎立本以此为题，绘制了这幅歌颂古代汉、藏民族友好交往的作品。画幅描绘的是唐太宗李世民在宫内接见松赞干布派来的吐蕃使臣禄东赞的情景。李世民端坐在由六名宫女抬着的坐榻（又称步辇，图画即以此为名）上，另有三个宫女分别在前后掌扇和持华盖。唐太宗面前站立三人：最右者，身穿大红袍，是这次仪式的引见官员；中间是吐蕃的使臣禄东赞，拱手而立，发型和服饰与中原地区不同；最左为一穿白袍的内官。按照画家阎立本当时的地位和身份，他完全可能是这次历史性会见的目击者，所以他笔下的人物非常真实、生动。唐太宗李世民的威严，使臣禄东赞的干练、谦和，引见官员和内侍的恭谨，年轻宫女的天真活泼，都各具特点，跃然绢上，禄东赞和唐太宗等人在民族气质上的差别也有所表现。全画以细劲的线条塑造人物形象，线条纯熟，富有变化和表现力；设色浓重、鲜艳，是一幅出色的工笔重彩人物画作品。图中的李世民、禄东赞等人应当带有肖像画特征。', 1, '/WenWu_Web_exploded/assets/Tang/picture/11001.jpg', 1, NOW()),
('韩滉五牛图卷', '唐', '《五牛图》是目前所见最早作于纸上的绘画，纸质为麻料，具有唐代纸张的特点。图画五牛，形象不一，姿态各异，或行或立，或俯首，或昂头，动态十足。其中一牛完全画成正面，视角独特，显示出作者高超的造型能力。作者以简洁的线条勾勒出牛的骨骼转折，筋肉缠裹，笔法老练流畅，线条富有力度和精确的艺术表现力。牛头部与口鼻处的根根细毛，更是笔笔入微。每头牛皆目光炯炯，作者通过对眼神的着力刻画，将牛既温顺又倔强的性格表现得极为传神。作品完全以牛为表现对象，无背景衬托，造型准确生动，设色清淡古朴，浓淡渲染有别，画面层次丰富，达到了形神兼备之境界。以牛入画是中国古代绘画的传统题材之一，体现了农业古国以农为本的主导思想。韩滉任职宰相期间，注重农业发展，此图可能含有鼓励农耕的意义。《五牛图》是其作品的传世孤本，也是为数寥寥的几件唐代纸绢绘画真迹之一，因此不论其艺术成就还是历史价值都备受世人关注。', 1, '/WenWu_Web_exploded/assets/Tang/picture/11002.jpg', 1, NOW());

-- 宋代文物
INSERT INTO cultural_relic (relic_name, dynasty, description, hall_id, image_path, created_by, created_at) VALUES
('青白釉狗', '宋', '小狗昂首侧卧，双目凝视，两耳下垂，脊背、四肢雕刻清晰。通体施青白釉。宋代青白瓷中的瓷塑作品十分丰富，这件青白釉瓷狗的表现手法以写实为主，详略结合，制作非常精细。', 2, '/WenWu_Web_exploded/assets/Song/ceram/20001.jpg', 1, NOW()),
('磁州窑白釉绿彩狗', '宋', '小狗昂首，身体直立，四肢立于一方形底座上。通体白釉绿彩装饰。磁州窑瓷塑的成就突出表现在一些儿童玩具上，包括小兔、小狗、牛篷车、羊、童子等，有的制品仅高几厘米，小巧玲珑。此件瓷塑小狗形象重在夸张，轮廓有些模糊，塑造手法极为简练，甚为可爱。', 2, '/WenWu_Web_exploded/assets/Song/ceram/20002.jpg', 1, NOW()),
('定窑白釉单柄杯', '宋', '杯呈漏斗形，敞口，斜直壁，圈足。外壁一侧置横"h"形柄。里外施白釉，口沿、足端无釉。', 2, '/WenWu_Web_exploded/assets/Song/ceram/20003.jpg', 1, NOW()),
('盘车图轴', '宋', '图中装满货物的牛车正在艰难地向山上行进，货物已将车架压得有些变形。一只小狗出现在车轮旁，一边高声呼叫着通知客人的到来，一边左右奔跑，似欲助牛车一臂之力，画家将小狗热情急切的心态表露无遗，亲切动人。', 2, '/WenWu_Web_exploded/assets/Song/picture/21001.jpg', 1, NOW()),
('梁楷（传）右军书扇图卷', '宋', '图绘王羲之为老妪书扇故事。本幅右边有梁楷题款，系后人添加，卷尾有元初赵由儁、张渊、钱良右、张世昌、石岩等人题跋，简笔人物的风格系仿自梁楷。', 2, '/WenWu_Web_exploded/assets/Song/picture/21002.jpg', 1, NOW()),
('行草书三札帖卷', '宋', '文彦博（1006—1097），字宽夫，号伊叟，汾州介休（今属山西）人。宋天圣五年（1027）进士。北宋著名政治家、书法家，"介休三贤"之一。文彦博历仕仁、英、神、哲四朝，出将入相五十年，被世人视为一代贤相。此三札均为文彦博任职河南府时所作，书法为其晚年风格。文彦博书法远学"二王"，近师颜真卿、杨凝式等。全帖通篇率性挥毫，用笔爽健清劲，将篆籀笔意融入行草，墨色枯湿亦变化强烈。', 2, '/WenWu_Web_exploded/assets/Song/shufa/22001.jpg', 1, NOW());

-- 元代文物
INSERT INTO cultural_relic (relic_name, dynasty, description, hall_id, image_path, created_by, created_at) VALUES
('龙泉窑青釉刻花牡丹纹玉壶春瓶', '元', '内外壁施青釉。外壁刻划装饰，共计6层，自上而下分别是蕉叶纹、回纹、卷草纹、缠技牡丹纹、仰莲瓣纹和回纹。在元代，内地制瓷业非常发达。据文献记载，玉壶春瓶作为元代瓷器的典型器形之一，也是中央赏赐西藏地方高僧的常见器物。', 3, '/WenWu_Web_exploded/assets/Yuan/ceram/30001.jpg', 2, NOW()),
('定窑白釉出戟水丞', '元', '水丞敛口，直腹，腹下斜收，小圈足。腹部有四道出戟棱柱。通体施白釉，圈足处无釉。水丞内附小勺一柄。水丞，又名水盂、水中丞，是用来盛水的文房用具。用内附的小勺将清水舀入砚上，再来研磨习字。明代屠隆撰《考槃余事》记载，宋代定窑、官窑、哥窑、龙泉窑等均烧造水丞，盛行一时。', 3, '/WenWu_Web_exploded/assets/Yuan/ceram/30002.jpg', 2, NOW()),
('赵孟頫葵花图轴', '元', '本幅自题："子昂写生。"钤"赵氏子昂"朱文印。鉴藏印："玉堤"朱文印，"兰陵龚策书画藏印"朱文印。赵孟頫提倡作画贵有古意，对唐至北宋的绘画风格多有摹仿。此图即采用五代西蜀黄筌父子的"黄体"——勾勒填彩的画法，线条细劲，敷色明净。因从现实生活中"写生"而来，秋葵姿态生动，比"黄体"更富有生机。此图画面简洁，笔法细润，风韵高雅，体现了赵氏所追求的古意与高华，是其早年花鸟画的代表作品。', 3, '/WenWu_Web_exploded/assets/Yuan/picture/31001.jpg', 2, NOW()),
('东山丝竹图轴', '元', '此图画东晋谢安东山丝竹故事。图绘崇山峻岭，连绵不绝，云雾缭绕，溪流蜿蜒山间。下部绘庭院一座，华屋数楹，院中仕女多抱管弦乐器，院外主人正携仆恭迎远来的贵宾们。全图表现了谢安迎客于东山、丝竹管弦高奏的情节，动态鲜明，仿佛有丝丝乐声流溢而出。而山水佳景清逸幽雅，衬托出主人高逸的情怀。图中人物刻画细腻，画法近于元末盛懋一路，具体作者不得而知。本幅左侧中部有后人添赵孟頫伪款一行。上部钤"嘉庆鉴赏"、"三希堂精鉴玺"、"宜子孙"、"嘉庆御览之宝"、"宣统御览之宝"、"石渠宝笈"、"宝笈三编"等印9方。此图原名《仙庄图》，著录于《石渠宝笈·三编》。', 3, '/WenWu_Web_exploded/assets/Yuan/picture/31002.jpg', 2, NOW()),
('赵孟頫行书临兰亭序卷', '元', '此卷原在赵孟頫"定武兰亭"十六跋后，之后被人分割，另装在南宋翻刻兰亭拓本后面。赵孟頫一生对《兰亭序》极为推重，曾反复临写，此件是其晚年所临，笔法精良。加之此卷前面有南宋翻刻定武《兰亭序》拓本，以及前后尤袤、王厚之、张翥、王蒙等宋元名家题跋，更为珍贵。本幅另有清代庆锡题跋一段。释文（略）。本幅款署"子昂"鉴藏印"伯谦精鉴"、"伯谦审定真迹"、"绍庭审定"、"蛰蛰公书画""龙友过眼"等。', 3, '/WenWu_Web_exploded/assets/Yuan/shufa/32001.jpg', 2, NOW()),
('吴镇草书心经卷', '元', '此卷书于元至元六年（1340年），为吴镇61岁时手录《心经》全文（内有误书多处），笔势遒逸，风味古澹，堪称炉火纯青。钤"梅花盦"朱文方印、"嘉兴吴镇仲圭书画记"白文方印。卷上还有清代刘墉、永瑆题跋及钱樾、周家谦等人鉴藏印记。', 3, '/WenWu_Web_exploded/assets/Yuan/shufa/32002.jpg', 2, NOW());

-- 明代文物
INSERT INTO cultural_relic (relic_name, dynasty, description, hall_id, image_path, created_by, created_at) VALUES
('祭蓝釉盘', '明', '此釉俗称"宝石蓝釉"，施该釉色的器物是明代御窑颜色釉瓷器中的佳作，亦是明廷赏赐西藏地方高僧的重要物品。盘底锥刻"大明宣德年制"六字双行款。', 4, '/WenWu_Web_exploded/assets/Ming/ceram/40001.jpg', 2, NOW()),
('仿定窑白釉花觚', '明', '花觚敞口，器身较直，圈足。通体施白釉，釉色白中泛黄。内配铜胆。觚为酒器，始见于新石器时代陶器，夏、商、周时期流行青铜觚。仿青铜觚的瓷质花瓶，俗称"花觚"，流行于元、明、清三代。', 4, '/WenWu_Web_exploded/assets/Ming/ceram/40002.jpg', 2, NOW()),
('丝路山水地图', '明', '这幅地图负载了大量原始的地理信息，它的出现以实物证明了在西方地图传入中国之前中国对世界地理，特别是对于丝绸之路沿线已有清晰的认识。全卷共画出了211个地理坐标，许多丝路上的重要城市，如中国的敦煌、乌兹别克斯坦的撒马尔罕、阿富汗的赫拉特、伊朗的伊斯法罕、叙利亚的大马士革等都有清晰的标注。蜿蜒两万公里的丝绸之路，是古人经济文化交流的重要纽带，延绵数千年的丝路历史，是世界文明的辉煌诗篇。2013年，习近平总书记提出了"一带一路"的倡议。这是为促进全球合作发展所提出的中国方案，是对人类幸福与世界和平的美好追求。以史为鉴，面向未来，《丝路山水地图》正是一把珍贵的钥匙，它将有助于学者们更深入地研究历史上的"丝绸之路"，并为未来"一带一路"的发展提供难能可贵的参考与借鉴。', 4, '/WenWu_Web_exploded/assets/Ming/picture/41001.jpg', 2, NOW()),
('《秋鸿》图谱册', '明', '《秋鸿》琴图谱册，共四册，图先谱后，为绘图与曲谱的合装本。册面装五色仿宋锦，素绢签，题楷书"琴谱"二字，并分别加注序号"平""沙""落""雁"四字于其下。每册前附页第一开和后附页最后一开上方钤"乾隆御览之宝"大印。该图谱册第一开为"清商调"和"夹钟清商意"两首练习曲，不见于其它琴谱集。在主题"秋鸿"二字下有两行小字标注"妙品夹钟清商曲，世为清商楚望谱，瓢翁、晓山翁累删"，"瓢翁"为南宋浙派古琴名家徐天民别号，"晓山"则为其孙徐梦吉之号，梦吉之子徐和仲名列洪武元年"文华堂"名琴家，并曾觐见过燕王朱棣。故此浙派徐门《秋鸿》图谱册，或为徐和仲所进献者，成书年代早于朱权的《神奇秘谱》，为存世最早的《秋鸿》版本之一。其水墨工笔绘画精美，极佳地表现了琴曲的意境，而且内容完整，减字谱准确度高，可谓古琴文化的珍宝。', 4, '/WenWu_Web_exploded/assets/Ming/picture/41002.jpg', 2, NOW()),
('行书记园中草木二十首卷', '明', '吴宽（1435—1504），字原博，号匏庵，长洲（今江苏苏州）人。明成化八年（1472）状元。行履高洁而自守以正。工诗文，有《匏庵家藏集》。善书法，规模苏轼，自成一格，为明代著名书法家。此卷为吴宽行书代表作，作品以诗记述园中诸草木。书法用笔温稳，字势俊朗。', 4, '/WenWu_Web_exploded/assets/Ming/shufa/42001.jpg', 2, NOW()),
('夏初札', '明', '徐光启（1562—1633），字子先，号玄扈，松江府上海县人。明万历三十二年（1604）进士。明代著名科学家。官至礼部尚书兼文渊阁大学士。著有《农政全书》，译《几何原本》，编纂《崇祯历书》。此作是徐光启写给亲家的一封信，信中说到时局日新，以至于典试的入场期也受到影响。典试，指主持考试之事。作品行草相间，用笔娴熟，结构紧密，书到连绵处一贯直下，气势夺人。', 4, '/WenWu_Web_exploded/assets/Ming/shufa/42002.jpg', 2, NOW());

-- 清代文物
INSERT INTO cultural_relic (relic_name, dynasty, description, hall_id, image_path, created_by, created_at) VALUES
('绿地粉彩勾莲八宝纹奔巴壶', '清', '奔巴壶原型是藏传佛教中的净水瓶。通体为青绿色底，上以蓝、白、绿、红、粉诸色绘制吉祥图案如八宝、莲花等。外底书"大清嘉庆年制"篆书款。清廷制作此类奔巴壶，既可供奉乾清宫佛堂中，同时也是赏赐西藏地区寺庙的法器之一。', 5, '/WenWu_Web_exploded/assets/Qing/ceram/50001.jpg', 3, NOW()),
('青花藏文祝词僧帽壶', '清', '此件为清代仿明初宣德风格样式器物。壶口内外绘缠枝灵芝纹，颈部绘八宝纹，肩部绘如意云头纹，腹中部书一周青花藏文吉祥祝词，意为"日安宁，夜安宁，日夜长久安宁，愿三宝保佑安宁。"近底处绘仰莲纹，内绘折技莲花纹。底部青花双圈内书四字楷书款"宣德年制"寄托款。类似器物在西藏寺庙中亦有收藏。', 5, '/WenWu_Web_exploded/assets/Qing/ceram/50002.jpg', 3, NOW()),
('戴熙忆松图卷', '清', '戴熙（1801—1860），字醇士，号棆庵、鹿床、花溪、井东居士，钱塘（今浙江杭州）人。清道光十二年（1832）进士。诗、书、画并臻绝诣。图绘叠岭层峦，云遮雾涌的山林。山间长松虬枝、溪水袅袅，雅境清幽。山石用披麻皴，染以墨色，浓墨加皴、点苔、勾树，增加画面层次。此幅构图较满，仅在题跋及云雾处透出空气感。', 5, '/WenWu_Web_exploded/assets/Qing/picture/51001.jpg', 3, NOW()),
('君子图轴', '清', '钱维城（1720-1772），初名辛来，字宗磬，号茶山、幼庵，晚号稼轩，江苏武进人。清乾隆十年（1745）状元。供奉内廷，为画苑领袖。图绘松、柏、梅、兰、水仙"五君子"。松与柏立于整个画面，虬枝盘曲、雄伟挺拔，梅花在其后盛开，自然优美，双勾水仙、撇出的墨兰则相伴左右。构图平中见奇，笔法清细繁复，格调柔雅静洁。', 5, '/WenWu_Web_exploded/assets/Qing/picture/51002.jpg', 3, NOW()),
('家书札', '清', '潘世恩（1770—1854），字槐堂，吴县（今江苏苏州）人。清乾隆五八年（1793）状元。曾任《四库全书》总裁及文颖馆总裁，负责《全唐文》的缮刊。著作有《读史镜古编》、《思补斋诗集》、《思补斋笔记》等。此作为潘世恩写给伯父潘奕隽的信札，信中先感谢伯父之前寄来所临的阁贴一事，又言及本年三月为伯父的七十大寿，并奉上礼品以示祝贺。', 5, '/WenWu_Web_exploded/assets/Qing/shufa/52001.jpg', 3, NOW()),
('致松门札', '清', '潘奕隽（1740—1830），字守愚，吴县（今江苏苏州）人。清乾隆三十四年（1769）进士。著《三松堂集》。为藏书世家，子潘世璜，孙潘遵祁、重孙潘介祉、后裔潘祖荫、潘承厚、潘承弼等均为藏书名家，收藏古籍、金石、书画甚富。此札为潘奕隽写给"松门"的书信，时值盛暑，说自己目力不佳，不便多写字。信札行草书数行，重笔磊落，轻笔飘逸，行书与草书结合并用，节奏生动，章法自然。', 5, '/WenWu_Web_exploded/assets/Qing/shufa/52002.jpg', 3, NOW());

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

-- 插入实名认证表测试数据（去掉证件类型字段）
INSERT INTO user_verification (user_id, real_name, phone, id_number, id_image_path, status, reject_reason, submitted_at, reviewed_at, reviewed_by) VALUES
(3, '张三', '12345678901', '123456789012345678', '/images/id_cards/user1.jpg', 'APPROVED', NULL, '2025-05-20 10:00:00', '2025-05-21 12:00:00', 2),
(4, '李四', '09876543211', 'A123456789', '/images/id_cards/user2.jpg', 'REJECTED', '证件号码错误', '2025-05-20 11:00:00', '2025-05-21 13:00:00', 1);


-- 禁用外键约束（防止删除数据时因外键约束报错）
SET FOREIGN_KEY_CHECKS = 0;
-- 删除所有表中的数据
DELETE FROM feedback;
DELETE FROM booking;
DELETE FROM news;
DELETE FROM cultural_relic;
DELETE FROM halls;
DELETE FROM user;
DELETE FROM user_verification;
-- 启用外键约束
SET FOREIGN_KEY_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 0;  -- 禁用外键约束（防止因外键依赖导致删除表失败）
DROP TABLE IF EXISTS feedback;          -- 删除用户反馈表
DROP TABLE IF EXISTS booking;          -- 删除预约记录表
DROP TABLE IF EXISTS news;            -- 删除新闻资讯表
DROP TABLE IF EXISTS cultural_relic;  -- 删除文物信息表
DROP TABLE IF EXISTS halls;           -- 删除展厅信息表
DROP TABLE IF EXISTS user_verification; -- 删除实名认证表
DROP TABLE IF EXISTS user;          -- 删除用户信息表
SET FOREIGN_KEY_CHECKS = 1;         -- 启用外键约束

```