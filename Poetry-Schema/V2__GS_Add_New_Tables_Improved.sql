-- ============================================================================
-- 中国古典诗词文学数据库 - 改进版 Schema
-- Chinese Classical Poetry & Literature Database - Improved Schema
-- Version: 2.0
-- 
-- 支持数据源:
--   - 五代诗词 (花间集、南唐二主词)
--   - 全唐诗 (~55,000首)
--   - 宋词 (~21,000首)
--   - 元曲
--   - 四书五经
--   - 诗经、楚辞
--   - 蒙学 (三字经、千字文等)
--   - 论语
--   - 个人诗集 (纳兰性德、曹操等)
-- ============================================================================

-- 创建扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 第一部分: 基础参考表
-- ============================================================================

-- 朝代表
CREATE TABLE dynasties (
    dynasty_code VARCHAR(20) PRIMARY KEY,
    dynasty_name VARCHAR(50) NOT NULL UNIQUE,
    dynasty_name_traditional VARCHAR(50),
    start_year INT,
    end_year INT,
    introduction TEXT,
    sequence INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE dynasties IS '朝代信息表';
COMMENT ON COLUMN dynasties.dynasty_code IS '朝代代码，如 tang, song, yuan';
COMMENT ON COLUMN dynasties.dynasty_name IS '朝代名称（简体）';
COMMENT ON COLUMN dynasties.dynasty_name_traditional IS '朝代名称（繁体）';
COMMENT ON COLUMN dynasties.sequence IS '朝代排序序号';

CREATE INDEX idx_dynasties_name ON dynasties(dynasty_name);
CREATE INDEX idx_dynasties_sequence ON dynasties(sequence);

-- 文学类别表
CREATE TABLE categories (
    category_code VARCHAR(50) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    parent_code VARCHAR(50) REFERENCES categories(category_code),
    description TEXT,
    sequence INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE categories IS '文学类别表（诗、词、曲、经、赋等）';
COMMENT ON COLUMN categories.parent_code IS '父类别代码，支持层级分类';

CREATE INDEX idx_categories_name ON categories(category_name);
CREATE INDEX idx_categories_parent ON categories(parent_code);

-- 词牌/曲牌表
CREATE TABLE rhythmic_patterns (
    rhythmic_code VARCHAR(100) PRIMARY KEY,
    rhythmic_name VARCHAR(100) NOT NULL,
    rhythmic_name_traditional VARCHAR(100),
    aliases TEXT[],
    poetry_type VARCHAR(20) CHECK (poetry_type IN ('词', '曲', '其他')),
    line_count INT,
    character_count INT,
    tone_pattern TEXT,
    rhyme_scheme TEXT,
    description TEXT,
    example_work_id UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE rhythmic_patterns IS '词牌/曲牌信息表';
COMMENT ON COLUMN rhythmic_patterns.rhythmic_name IS '词牌名，如"菩萨蛮"、"水调歌头"';
COMMENT ON COLUMN rhythmic_patterns.aliases IS '别名数组';
COMMENT ON COLUMN rhythmic_patterns.tone_pattern IS '平仄格式模板';
COMMENT ON COLUMN rhythmic_patterns.rhyme_scheme IS '押韵规则描述';

CREATE INDEX idx_rhythmic_name ON rhythmic_patterns(rhythmic_name);
CREATE INDEX idx_rhythmic_type ON rhythmic_patterns(poetry_type);
CREATE UNIQUE INDEX idx_rhythmic_name_unique ON rhythmic_patterns(rhythmic_name) 
    WHERE rhythmic_name IS NOT NULL;

-- ============================================================================
-- 第二部分: 作者表
-- ============================================================================

CREATE TABLE authors (
    author_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    author_code VARCHAR(100) NOT NULL,
    author_name VARCHAR(100) NOT NULL,
    author_name_traditional VARCHAR(100),
    courtesy_name VARCHAR(100),
    pseudonym VARCHAR(200),
    dynasty_code VARCHAR(20) REFERENCES dynasties(dynasty_code),
    birth_year INT,
    death_year INT,
    birth_year_uncertain BOOLEAN DEFAULT FALSE,
    death_year_uncertain BOOLEAN DEFAULT FALSE,
    birthplace VARCHAR(200),
    official_positions TEXT,
    short_description TEXT,
    biography TEXT,
    life_story TEXT,
    achievements TEXT,
    literary_style TEXT,
    avatar_path TEXT,
    source_file VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_author_code UNIQUE(author_code),
    CONSTRAINT unique_author_in_dynasty UNIQUE(author_name, dynasty_code)
);

COMMENT ON TABLE authors IS '作者信息表';
COMMENT ON COLUMN authors.author_code IS '作者唯一代码';
COMMENT ON COLUMN authors.courtesy_name IS '字，如苏轼字"子瞻"';
COMMENT ON COLUMN authors.pseudonym IS '号，如苏轼号"东坡居士"，可有多个';
COMMENT ON COLUMN authors.birth_year_uncertain IS '生年是否为推测';
COMMENT ON COLUMN authors.short_description IS 'JSON源数据中的desc字段';
COMMENT ON COLUMN authors.literary_style IS '文学风格特点';

CREATE INDEX idx_authors_code ON authors(author_code);
CREATE INDEX idx_authors_name ON authors(author_name);
CREATE INDEX idx_authors_dynasty ON authors(dynasty_code);
CREATE INDEX idx_authors_courtesy ON authors(courtesy_name);
CREATE INDEX idx_authors_pseudonym ON authors(pseudonym);
CREATE INDEX idx_authors_birth_year ON authors(birth_year);

-- ============================================================================
-- 第三部分: 作品集/文集表（用于四书五经等层级结构）
-- ============================================================================

CREATE TABLE collections (
    collection_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    collection_code VARCHAR(100) NOT NULL UNIQUE,
    collection_name VARCHAR(200) NOT NULL,
    collection_name_traditional VARCHAR(200),
    category_code VARCHAR(50) REFERENCES categories(category_code),
    dynasty_code VARCHAR(20) REFERENCES dynasties(dynasty_code),
    author_id UUID REFERENCES authors(author_id),
    description TEXT,
    chapter_count INT,
    source_directory VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE collections IS '作品集/文集表（如《论语》、《诗经》整部作品）';
COMMENT ON COLUMN collections.source_directory IS '数据源目录路径';

CREATE INDEX idx_collections_code ON collections(collection_code);
CREATE INDEX idx_collections_name ON collections(collection_name);
CREATE INDEX idx_collections_category ON collections(category_code);

-- 章节表（用于四书五经、诗经等有章节结构的作品）
CREATE TABLE chapters (
    chapter_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    collection_id UUID NOT NULL REFERENCES collections(collection_id) ON DELETE CASCADE,
    chapter_number INT NOT NULL,
    chapter_title VARCHAR(200),
    chapter_title_traditional VARCHAR(200),
    chapter_subtitle VARCHAR(200),
    chapter_content TEXT,
    section_count INT,
    sequence INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_chapter_in_collection UNIQUE(collection_id, chapter_number)
);

COMMENT ON TABLE chapters IS '章节表（如《论语》的"学而篇"、《诗经》的"国风"）';

CREATE INDEX idx_chapters_collection ON chapters(collection_id);
CREATE INDEX idx_chapters_sequence ON chapters(sequence);

-- 小节表（章节下的细分）
CREATE TABLE sections (
    section_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chapter_id UUID NOT NULL REFERENCES chapters(chapter_id) ON DELETE CASCADE,
    section_number INT NOT NULL,
    section_title VARCHAR(200),
    section_content TEXT,
    sequence INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_section_in_chapter UNIQUE(chapter_id, section_number)
);

COMMENT ON TABLE sections IS '小节表（章节下的细分内容）';

CREATE INDEX idx_sections_chapter ON sections(chapter_id);
CREATE INDEX idx_sections_sequence ON sections(sequence);

-- ============================================================================
-- 第四部分: 作品表（核心表）
-- ============================================================================

CREATE TABLE works (
    work_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_code VARCHAR(200),
    title VARCHAR(500) NOT NULL,
    title_traditional VARCHAR(500),
    subtitle VARCHAR(500),
    author_id UUID REFERENCES authors(author_id),
    dynasty_code VARCHAR(20) REFERENCES dynasties(dynasty_code),
    category_code VARCHAR(50) REFERENCES categories(category_code),
    rhythmic_code VARCHAR(100) REFERENCES rhythmic_patterns(rhythmic_code),
    collection_id UUID REFERENCES collections(collection_id),
    chapter_id UUID REFERENCES chapters(chapter_id),
    
    preface TEXT,
    description TEXT,
    description_reference TEXT,
    introduction TEXT,
    introduction_reference TEXT,
    translation TEXT,
    translation_reference TEXT,
    
    source_collection VARCHAR(100),
    source_file VARCHAR(500),
    source_index INT,
    original_id VARCHAR(200),
    import_batch_id VARCHAR(50),
    
    view_count INT DEFAULT 0,
    like_count INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE works IS '作品主表（诗、词、曲等单篇作品）';
COMMENT ON COLUMN works.work_code IS '作品唯一代码';
COMMENT ON COLUMN works.rhythmic_code IS '词牌/曲牌代码（仅词、曲使用）';
COMMENT ON COLUMN works.collection_id IS '所属文集（如属于《全唐诗》）';
COMMENT ON COLUMN works.preface IS '序言/题记';
COMMENT ON COLUMN works.source_collection IS '数据来源集合名，如"宋词"、"全唐诗"';
COMMENT ON COLUMN works.source_file IS '原始JSON文件路径';
COMMENT ON COLUMN works.source_index IS '在原始文件中的索引位置';
COMMENT ON COLUMN works.original_id IS '原始数据中的ID';

CREATE INDEX idx_works_code ON works(work_code);
CREATE INDEX idx_works_title ON works(title);
CREATE INDEX idx_works_author ON works(author_id);
CREATE INDEX idx_works_dynasty ON works(dynasty_code);
CREATE INDEX idx_works_category ON works(category_code);
CREATE INDEX idx_works_rhythmic ON works(rhythmic_code);
CREATE INDEX idx_works_collection ON works(collection_id);
CREATE INDEX idx_works_source ON works(source_collection);
CREATE INDEX idx_works_import_batch ON works(import_batch_id);
CREATE INDEX idx_works_featured ON works(is_featured) WHERE is_featured = TRUE;

CREATE INDEX idx_works_dynasty_category ON works(dynasty_code, category_code);
CREATE INDEX idx_works_author_dynasty ON works(author_id, dynasty_code);

-- ============================================================================
-- 第五部分: 作品内容表
-- ============================================================================

-- 段落/诗句表
CREATE TABLE paragraphs (
    paragraph_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_id UUID NOT NULL REFERENCES works(work_id) ON DELETE CASCADE,
    sequence INT NOT NULL,
    content TEXT NOT NULL,
    content_traditional TEXT,
    is_title_line BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_paragraph_sequence UNIQUE(work_id, sequence)
);

COMMENT ON TABLE paragraphs IS '作品段落/诗句表';
COMMENT ON COLUMN paragraphs.sequence IS '段落序号，从1开始';
COMMENT ON COLUMN paragraphs.is_title_line IS '是否为标题行（某些词有小序）';

CREATE INDEX idx_paragraphs_work ON paragraphs(work_id);
CREATE INDEX idx_paragraphs_sequence ON paragraphs(work_id, sequence);

-- 平仄格式表
CREATE TABLE tone_patterns (
    pattern_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_id UUID NOT NULL REFERENCES works(work_id) ON DELETE CASCADE,
    line_number INT NOT NULL,
    pattern TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_tone_pattern UNIQUE(work_id, line_number)
);

COMMENT ON TABLE tone_patterns IS '作品平仄格式表（对应JSON中的strains字段）';
COMMENT ON COLUMN tone_patterns.pattern IS '平仄格式，如"平平仄仄平平仄"';

CREATE INDEX idx_tone_patterns_work ON tone_patterns(work_id);

-- ============================================================================
-- 第六部分: 注释与赏析
-- ============================================================================

-- 作品注释表（对应JSON中的notes数组）
CREATE TABLE work_notes (
    note_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_id UUID NOT NULL REFERENCES works(work_id) ON DELETE CASCADE,
    note_index INT NOT NULL,
    note_content TEXT NOT NULL,
    note_type VARCHAR(20) DEFAULT 'original' 
        CHECK (note_type IN ('original', 'editorial', 'scholarly')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_work_note UNIQUE(work_id, note_index)
);

COMMENT ON TABLE work_notes IS '作品原始注释表（来自JSON的notes字段）';
COMMENT ON COLUMN work_notes.note_index IS '注释序号';
COMMENT ON COLUMN work_notes.note_type IS 'original=原始数据注释, editorial=编辑注释, scholarly=学术注释';

CREATE INDEX idx_work_notes_work ON work_notes(work_id);

-- 词语注释表（详细解释特定词语）
CREATE TABLE annotations (
    annotation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_id UUID NOT NULL REFERENCES works(work_id) ON DELETE CASCADE,
    term VARCHAR(200) NOT NULL,
    term_position INT,
    line_number INT,
    explanation TEXT NOT NULL,
    pronunciation VARCHAR(100),
    reference TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE annotations IS '词语注释表（详细解释特定词语或典故）';
COMMENT ON COLUMN annotations.term IS '被注释的词语';
COMMENT ON COLUMN annotations.term_position IS '词语在文本中的位置';
COMMENT ON COLUMN annotations.pronunciation IS '读音/注音';

CREATE INDEX idx_annotations_work ON annotations(work_id);
CREATE INDEX idx_annotations_term ON annotations(term);

-- 赏析表
CREATE TABLE appreciations (
    appreciation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_id UUID NOT NULL REFERENCES works(work_id) ON DELETE CASCADE,
    title VARCHAR(200),
    content TEXT NOT NULL,
    author_name VARCHAR(100),
    source VARCHAR(200),
    reference TEXT,
    appreciation_type VARCHAR(20) DEFAULT 'general'
        CHECK (appreciation_type IN ('general', 'artistic', 'historical', 'linguistic')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE appreciations IS '作品赏析表';
COMMENT ON COLUMN appreciations.appreciation_type IS '赏析类型：general=综合, artistic=艺术, historical=历史, linguistic=语言';

CREATE INDEX idx_appreciations_work ON appreciations(work_id);
CREATE INDEX idx_appreciations_type ON appreciations(appreciation_type);

-- ============================================================================
-- 第七部分: 标签系统
-- ============================================================================

CREATE TABLE tags (
    tag_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tag_name VARCHAR(100) NOT NULL UNIQUE,
    tag_category VARCHAR(50),
    description TEXT,
    usage_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE tags IS '标签表';
COMMENT ON COLUMN tags.tag_category IS '标签分类，如"主题"、"情感"、"季节"';

CREATE INDEX idx_tags_name ON tags(tag_name);
CREATE INDEX idx_tags_category ON tags(tag_category);
CREATE INDEX idx_tags_usage ON tags(usage_count DESC);

CREATE TABLE work_tags (
    work_id UUID NOT NULL REFERENCES works(work_id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(tag_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (work_id, tag_id)
);

COMMENT ON TABLE work_tags IS '作品-标签关联表';

CREATE INDEX idx_work_tags_work ON work_tags(work_id);
CREATE INDEX idx_work_tags_tag ON work_tags(tag_id);

-- ============================================================================
-- 第八部分: 作者轶闻与关联
-- ============================================================================

CREATE TABLE anecdotes (
    anecdote_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    author_id UUID NOT NULL REFERENCES authors(author_id) ON DELETE CASCADE,
    title VARCHAR(200),
    content TEXT NOT NULL,
    source VARCHAR(200),
    reference TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE anecdotes IS '作者轶闻/故事表';

CREATE INDEX idx_anecdotes_author ON anecdotes(author_id);

-- 作者关系表（师生、友人、亲属等）
CREATE TABLE author_relationships (
    relationship_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    author_id_1 UUID NOT NULL REFERENCES authors(author_id) ON DELETE CASCADE,
    author_id_2 UUID NOT NULL REFERENCES authors(author_id) ON DELETE CASCADE,
    relationship_type VARCHAR(50) NOT NULL 
        CHECK (relationship_type IN ('师生', '友人', '亲属', '同门', '政敌', '其他')),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_author_relationship UNIQUE(author_id_1, author_id_2, relationship_type),
    CONSTRAINT no_self_relationship CHECK (author_id_1 <> author_id_2)
);

COMMENT ON TABLE author_relationships IS '作者关系表';

CREATE INDEX idx_author_rel_1 ON author_relationships(author_id_1);
CREATE INDEX idx_author_rel_2 ON author_relationships(author_id_2);

-- ============================================================================
-- 第九部分: 数据导入追踪
-- ============================================================================

CREATE TABLE import_batches (
    batch_id VARCHAR(50) PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL,
    source_directory VARCHAR(500),
    file_count INT,
    record_count INT,
    status VARCHAR(20) DEFAULT 'pending'
        CHECK (status IN ('pending', 'running', 'completed', 'failed')),
    error_message TEXT,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE import_batches IS '数据导入批次记录表';

CREATE INDEX idx_import_batches_status ON import_batches(status);
CREATE INDEX idx_import_batches_source ON import_batches(source_name);

CREATE TABLE import_errors (
    error_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    batch_id VARCHAR(50) REFERENCES import_batches(batch_id),
    source_file VARCHAR(500),
    record_index INT,
    error_type VARCHAR(50),
    error_message TEXT,
    raw_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE import_errors IS '导入错误记录表';

CREATE INDEX idx_import_errors_batch ON import_errors(batch_id);

-- ============================================================================
-- 第十部分: 视图
-- ============================================================================

-- 作品完整内容视图
CREATE VIEW v_works_full AS
SELECT 
    w.work_id,
    w.title,
    w.subtitle,
    a.author_name,
    a.courtesy_name AS author_courtesy_name,
    a.pseudonym AS author_pseudonym,
    d.dynasty_name,
    c.category_name,
    rp.rhythmic_name,
    w.preface,
    string_agg(p.content, E'\n' ORDER BY p.sequence) AS full_content,
    w.translation,
    w.source_collection,
    w.created_at
FROM works w
LEFT JOIN authors a ON w.author_id = a.author_id
LEFT JOIN dynasties d ON w.dynasty_code = d.dynasty_code
LEFT JOIN categories c ON w.category_code = c.category_code
LEFT JOIN rhythmic_patterns rp ON w.rhythmic_code = rp.rhythmic_code
LEFT JOIN paragraphs p ON w.work_id = p.work_id
GROUP BY w.work_id, a.author_name, a.courtesy_name, a.pseudonym, 
         d.dynasty_name, c.category_name, rp.rhythmic_name;

COMMENT ON VIEW v_works_full IS '作品完整信息视图，包含拼接的全文内容';

-- 作者统计视图
CREATE VIEW v_author_stats AS
SELECT 
    a.author_id,
    a.author_name,
    a.courtesy_name,
    a.pseudonym,
    d.dynasty_name,
    COUNT(DISTINCT w.work_id) AS work_count,
    COUNT(DISTINCT w.category_code) AS category_count,
    array_agg(DISTINCT c.category_name) FILTER (WHERE c.category_name IS NOT NULL) AS categories
FROM authors a
LEFT JOIN dynasties d ON a.dynasty_code = d.dynasty_code
LEFT JOIN works w ON a.author_id = w.author_id
LEFT JOIN categories c ON w.category_code = c.category_code
GROUP BY a.author_id, d.dynasty_name;

COMMENT ON VIEW v_author_stats IS '作者统计信息视图';

-- 朝代统计视图
CREATE VIEW v_dynasty_stats AS
SELECT 
    d.dynasty_code,
    d.dynasty_name,
    d.start_year,
    d.end_year,
    COUNT(DISTINCT a.author_id) AS author_count,
    COUNT(DISTINCT w.work_id) AS work_count
FROM dynasties d
LEFT JOIN authors a ON d.dynasty_code = a.dynasty_code
LEFT JOIN works w ON d.dynasty_code = w.dynasty_code
GROUP BY d.dynasty_code
ORDER BY d.sequence;

COMMENT ON VIEW v_dynasty_stats IS '朝代统计信息视图';

-- ============================================================================
-- 第十一部分: 触发器
-- ============================================================================

-- 自动更新 updated_at 字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_dynasties_updated_at
    BEFORE UPDATE ON dynasties
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_authors_updated_at
    BEFORE UPDATE ON authors
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_collections_updated_at
    BEFORE UPDATE ON collections
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_works_updated_at
    BEFORE UPDATE ON works
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 自动更新标签使用计数
CREATE OR REPLACE FUNCTION update_tag_usage_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE tags SET usage_count = usage_count + 1 WHERE tag_id = NEW.tag_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE tags SET usage_count = usage_count - 1 WHERE tag_id = OLD.tag_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_work_tags_count
    AFTER INSERT OR DELETE ON work_tags
    FOR EACH ROW EXECUTE FUNCTION update_tag_usage_count();

-- ============================================================================
-- 第十二部分: 初始化数据
-- ============================================================================

-- 插入朝代数据（来源: V3__GS_Add_New_Data.sql）
INSERT INTO dynasties (dynasty_code, dynasty_name, start_year, end_year, introduction, sequence) VALUES
('xia', '夏', -2100, -1600, '夏朝是中国历史上第一个王朝，相传由大禹建立。夏朝的建立标志着中国奴隶社会的开始。', 1),
('shang', '商', -1600, -1046, '商朝是中国历史上第一个有明确文字记载的王朝，以其高度发展的青铜器文明著称。商朝的都城在今河南安阳，遗址被称为殷墟。', 2),
('xi_zhou', '西周', -1046, -771, '周朝分为西周和东周两个时期。西周实行封建制度，周武王建立了周朝，并以洛阳为中心进行统治。', 3),
('dong_zhou', '东周', -770, -256, '东周包括春秋和战国两个时期，是中国思想和文化大发展的时代。春秋时期百家争鸣，战国时期七雄争霸。', 4),
('qin', '秦', -221, -206, '秦朝由秦始皇建立，统一了中国，建立了中央集权制度，并开始修建长城。秦始皇还统一了文字、货币和度量衡。', 5),
('xi_han', '西汉', -206, 9, '西汉是中国历史上的黄金时代之一，建立了稳定的中央集权制度，经济文化得到大发展。著名的丝绸之路就是在西汉时期开辟的。', 6),
('dong_han', '东汉', 25, 220, '东汉延续了西汉的制度和文化，是中国古代科学技术发展的重要时期。东汉末年，黄巾起义爆发，最终导致三国时期的到来。', 7),
('san_guo', '三国', 220, 280, '三国时期是魏、蜀、吴三国争霸的时代，充满了战争和英雄传说。三国时期的故事被后来的《三国演义》所演绎。', 8),
('xi_jin', '西晋', 265, 316, '西晋由司马炎建立，短暂统一了中国，但很快陷入了内部动荡和北方游牧民族的侵扰。', 9),
('dong_jin', '东晋', 317, 420, '东晋在南方建立，北方则进入十六国时期。东晋以健康（今南京）为都城，是南北朝时期的南朝之一。', 10),
('nan_bei_chao', '南北朝', 420, 589, '南北朝是中国历史上的动荡时期，南朝和北朝各自建立政权，彼此对峙。这个时期也是佛教在中国广泛传播的时期。', 11),
('sui', '隋', 581, 618, '隋朝统一了中国，结束了南北朝的分裂局面。隋朝开创了科举制度，并修建了大运河。隋炀帝在位时修建的大运河对中国的经济和交通产生了深远影响。', 12),
('tang', '唐', 618, 907, '唐朝是中国历史上的黄金时代，文化、经济和军事都达到了顶峰。唐朝是中国古代诗歌的巅峰时期,涌现出了李白、杜甫等伟大诗人。', 13),
('wu_dai_shi_guo', '五代十国', 907, 960, '五代十国是唐朝灭亡后,中国再次陷入分裂的时期。北方经历了五个短命的王朝,而南方则有十个地方政权。', 14),
('bei_song', '北宋', 960, 1127, '北宋以文治著称,科技和文化都有很大发展。北宋的经济繁荣,城市建设和商业活动都非常发达。', 15),
('nan_song', '南宋', 1127, 1279, '南宋是北宋灭亡后在南方建立的王朝,延续了宋朝的文化传统。南宋以杭州为都城,经济文化依旧繁荣。', 16),
('yuan', '元', 1271, 1368, '元朝由蒙古人建立,是中国历史上第一个由少数民族统治的全国性王朝。元朝的疆域广阔,首都在大都（今北京）。', 17),
('ming', '明', 1368, 1644, '明朝以恢复汉族统治为特征,经济和文化都有很大发展。明朝建立了强大的中央集权政府,并进行了多次海外探险。', 18),
('qing', '清', 1644, 1912, '清朝是中国历史上的最后一个封建王朝,由满族人建立。清朝在康乾盛世期间达到了顶峰,但随后逐渐衰落,最终在辛亥革命中被推翻。', 19),
('unknown', '未知', NULL, NULL, '未知朝代或跨朝代作品。', 99);

-- 插入文学类别数据（来源: V3__GS_Add_New_Data.sql + 扩展）
INSERT INTO categories (category_code, category_name, parent_code, sequence) VALUES
('wudaishici', '五代诗词', NULL, 1),
('yuanqu', '元曲', NULL, 2),
('quantangshi', '全唐诗', NULL, 3),
('sishuuwujing', '四书五经', NULL, 4),
('songci', '宋词', NULL, 5),
('youmengying', '幽梦影', NULL, 6),
('yudingquantangshi', '御定全唐詩', NULL, 7),
('caocaoshiji', '曹操诗集', NULL, 8),
('chuci', '楚辞', NULL, 9),
('shuimotangshi', '水墨唐诗', NULL, 10),
('nalanxingde', '纳兰性德', NULL, 11),
('mengxue', '蒙学', NULL, 12),
('lunyu', '论语', NULL, 13),
('shijing', '诗经', NULL, 14),
('other', '其他', NULL, 99);

-- ============================================================================
-- 第十三部分: 全文搜索支持（可选，需要中文分词扩展）
-- ============================================================================

-- 注意：以下代码需要安装 zhparser 或 pg_jieba 扩展
-- 如果没有安装中文分词扩展，可以跳过此部分

-- 检查并创建中文搜索配置（如果扩展存在）
DO $$
BEGIN
    -- 尝试创建中文分词配置
    IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'zhparser') THEN
        -- zhparser 扩展存在
        EXECUTE 'CREATE TEXT SEARCH CONFIGURATION IF NOT EXISTS chinese_cfg (PARSER = zhparser)';
        EXECUTE 'ALTER TEXT SEARCH CONFIGURATION chinese_cfg ADD MAPPING FOR n,v,a,i,e,l WITH simple';
        
        -- 添加全文搜索列
        EXECUTE 'ALTER TABLE works ADD COLUMN IF NOT EXISTS search_vector tsvector';
        
        -- 创建 GIN 索引
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_works_search ON works USING GIN(search_vector)';
        
        RAISE NOTICE 'Chinese full-text search configured with zhparser';
    ELSIF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_jieba') THEN
        -- pg_jieba 扩展存在
        RAISE NOTICE 'pg_jieba extension found, configure manually';
    ELSE
        RAISE NOTICE 'No Chinese text search extension found. Full-text search will use simple configuration.';
        
        -- 使用简单配置作为后备
        EXECUTE 'ALTER TABLE works ADD COLUMN IF NOT EXISTS search_vector tsvector';
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_works_search ON works USING GIN(search_vector)';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Full-text search setup skipped: %', SQLERRM;
END $$;

-- ============================================================================
-- 完成
-- ============================================================================

-- 显示表统计
DO $$
DECLARE
    table_count INT;
    view_count INT;
    index_count INT;
BEGIN
    SELECT COUNT(*) INTO table_count FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
    
    SELECT COUNT(*) INTO view_count FROM information_schema.views 
    WHERE table_schema = 'public';
    
    SELECT COUNT(*) INTO index_count FROM pg_indexes 
    WHERE schemaname = 'public';
    
    RAISE NOTICE '';
    RAISE NOTICE '============================================';
    RAISE NOTICE '中国古典诗词文学数据库 Schema 创建完成！';
    RAISE NOTICE '============================================';
    RAISE NOTICE '创建的表数量: %', table_count;
    RAISE NOTICE '创建的视图数量: %', view_count;
    RAISE NOTICE '创建的索引数量: %', index_count;
    RAISE NOTICE '============================================';
END $$;
