-- ============================================================================
-- Seed Reference Data for Chinese Poetry Database
-- ============================================================================

-- 朝代数据 (Dynasties)
INSERT INTO dynasties (dynasty_code, dynasty_name, dynasty_name_traditional, start_year, end_year, sequence) VALUES
                                                                                                                 ('pre_qin', '先秦', '先秦', -2070, -221, 1),
                                                                                                                 ('qin', '秦', '秦', -221, -206, 2),
                                                                                                                 ('han', '汉', '漢', -206, 220, 3),
                                                                                                                 ('three_kingdoms', '三国', '三國', 220, 280, 4),
                                                                                                                 ('jin', '晋', '晉', 265, 420, 5),
                                                                                                                 ('southern_northern', '南北朝', '南北朝', 420, 589, 6),
                                                                                                                 ('sui', '隋', '隋', 581, 618, 7),
                                                                                                                 ('tang', '唐', '唐', 618, 907, 8),
                                                                                                                 ('five_dynasties', '五代十国', '五代十國', 907, 979, 9),
                                                                                                                 ('song', '宋', '宋', 960, 1279, 10),
                                                                                                                 ('yuan', '元', '元', 1271, 1368, 11),
                                                                                                                 ('ming', '明', '明', 1368, 1644, 12),
                                                                                                                 ('qing', '清', '清', 1644, 1912, 13),
                                                                                                                 ('modern', '近现代', '近現代', 1912, 2000, 14),
                                                                                                                 ('unknown', '未知', '未知', NULL, NULL, 99);

-- 文学类别数据 (Categories)
INSERT INTO categories (category_code, category_name, parent_code, description, sequence) VALUES
                                                                                              ('shi', '诗', NULL, '诗歌，包括古诗、律诗、绝句等', 1),
                                                                                              ('ci', '词', NULL, '词，按词牌填写的诗歌形式', 2),
                                                                                              ('qu', '曲', NULL, '曲，包括散曲和杂剧', 3),
                                                                                              ('fu', '赋', NULL, '赋，介于诗歌和散文之间的文体', 4),
                                                                                              ('jing', '经', NULL, '经典，包括儒家经典', 5),
                                                                                              ('mengxue', '蒙学', NULL, '蒙学读物，儿童启蒙教材', 6),
                                                                                              ('wenxuan', '文选', NULL, '文选，文学作品选集', 7),
                                                                                              ('gushi', '古诗', 'shi', '古体诗', 11),
                                                                                              ('lvshi', '律诗', 'shi', '格律诗', 12),
                                                                                              ('jueju', '绝句', 'shi', '绝句', 13),
                                                                                              ('xiaoci', '小令', 'ci', '短词，58字以内', 21),
                                                                                              ('zhongdiao', '中调', 'ci', '中调词，59-90字', 22),
                                                                                              ('changdiao', '长调', 'ci', '长调词，91字以上', 23),
                                                                                              ('sanqu', '散曲', 'qu', '散曲', 31),
                                                                                              ('zaju', '杂剧', 'qu', '杂剧', 32);
