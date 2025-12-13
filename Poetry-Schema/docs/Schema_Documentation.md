# 中国古典诗词文学数据库 - Schema 说明文档

## 概述

本数据库设计用于存储中国古典诗词文学数据，支持从先秦到近代的所有文学体裁。

---

## 一、基础参考表

### 1.1 dynasties (朝代表)

存储中国历史朝代信息，预置15个朝代。

| 字段 | 类型 | 说明 |
|------|------|------|
| dynasty_code | VARCHAR(20) | 主键，朝代代码 (如 tang, song) |
| dynasty_name | VARCHAR(50) | 朝代名称（简体） |
| dynasty_name_traditional | VARCHAR(50) | 朝代名称（繁体） |
| start_year | INT | 起始年份（负数表示公元前） |
| end_year | INT | 结束年份 |
| introduction | TEXT | 朝代简介 |
| sequence | INT | 排序序号 |

**预置数据**: 先秦、秦、汉、魏晋、南北朝、隋、唐、五代、宋、元、明、清、近代、当代、未知

---

### 1.2 categories (文学类别表)

支持层级分类的文学体裁。

| 字段 | 类型 | 说明 |
|------|------|------|
| category_code | VARCHAR(50) | 主键，类别代码 |
| category_name | VARCHAR(100) | 类别名称 |
| parent_code | VARCHAR(50) | 父类别代码（自关联） |
| description | TEXT | 描述 |
| sequence | INT | 排序序号 |

**层级示例**:
```
诗 (shi)
├── 古诗 (shi_gushi)
├── 律诗 (shi_lvshi)
├── 绝句 (shi_jueju)
└── 乐府 (shi_yuefu)

词 (ci)
├── 小令 (ci_xiaoling)
├── 中调 (ci_zhongdiao)
└── 长调 (ci_changdiao)
```

---

### 1.3 rhythmic_patterns (词牌/曲牌表)

存储词牌和曲牌的格律信息。

| 字段 | 类型 | 说明 |
|------|------|------|
| rhythmic_code | VARCHAR(100) | 主键，词牌代码 |
| rhythmic_name | VARCHAR(100) | 词牌名（如"菩萨蛮"） |
| aliases | TEXT[] | 别名数组 |
| poetry_type | VARCHAR(20) | 类型：词/曲/其他 |
| line_count | INT | 行数 |
| character_count | INT | 字数 |
| tone_pattern | TEXT | 平仄格式模板 |
| rhyme_scheme | TEXT | 押韵规则 |

**对应 JSON 字段**: `rhythmic`

---

## 二、作者表

### 2.1 authors (作者表)

存储诗人/词人详细信息。

| 字段 | 类型 | 说明 |
|------|------|------|
| author_id | UUID | 主键 |
| author_code | VARCHAR(100) | 唯一代码 |
| author_name | VARCHAR(100) | 姓名 |
| courtesy_name | VARCHAR(100) | 字（如苏轼字"子瞻"） |
| pseudonym | VARCHAR(200) | 号（如"东坡居士"） |
| dynasty_code | VARCHAR(20) | 外键→朝代 |
| birth_year | INT | 生年 |
| death_year | INT | 卒年 |
| birth_year_uncertain | BOOLEAN | 生年是否推测 |
| birthplace | VARCHAR(200) | 籍贯 |
| official_positions | TEXT | 官职列表 |
| short_description | TEXT | 简述（对应 JSON 的 desc） |
| biography | TEXT | 生平传记 |
| literary_style | TEXT | 文学风格 |

**对应 JSON 字段**: `author`, `name`, `desc`

---

## 三、作品集层级结构

用于四书五经、诗经等有章节结构的文献。

### 3.1 collections (文集表)

| 字段 | 类型 | 说明 |
|------|------|------|
| collection_id | UUID | 主键 |
| collection_code | VARCHAR(100) | 唯一代码 |
| collection_name | VARCHAR(200) | 文集名（如"论语"） |
| category_code | VARCHAR(50) | 外键→类别 |
| dynasty_code | VARCHAR(20) | 外键→朝代 |
| source_directory | VARCHAR(500) | 数据源目录 |

### 3.2 chapters (章表)

| 字段 | 类型 | 说明 |
|------|------|------|
| chapter_id | UUID | 主键 |
| collection_id | UUID | 外键→文集 |
| chapter_number | INT | 章号 |
| chapter_title | VARCHAR(200) | 章标题（如"学而篇"） |
| chapter_content | TEXT | 章内容 |

### 3.3 sections (节表)

| 字段 | 类型 | 说明 |
|------|------|------|
| section_id | UUID | 主键 |
| chapter_id | UUID | 外键→章 |
| section_number | INT | 节号 |
| section_title | VARCHAR(200) | 节标题 |
| section_content | TEXT | 节内容 |

---

## 四、作品核心表

### 4.1 works (作品主表)

核心表，存储每篇作品的元数据。

| 字段 | 类型 | 说明 |
|------|------|------|
| work_id | UUID | 主键 |
| title | VARCHAR(500) | 标题 |
| subtitle | VARCHAR(500) | 副标题 |
| author_id | UUID | 外键→作者 |
| dynasty_code | VARCHAR(20) | 外键→朝代 |
| category_code | VARCHAR(50) | 外键→类别 |
| rhythmic_code | VARCHAR(100) | 外键→词牌（词/曲专用） |
| collection_id | UUID | 外键→文集 |
| preface | TEXT | 序言/题记 |
| translation | TEXT | 现代汉语翻译 |
| source_collection | VARCHAR(100) | 来源集合名 |
| source_file | VARCHAR(500) | 原始文件路径 |
| source_index | INT | 文件中索引 |

**对应 JSON 字段**: `title`, `author`, `rhythmic`

---

### 4.2 paragraphs (段落表)

存储作品的每行/每段内容。

| 字段 | 类型 | 说明 |
|------|------|------|
| paragraph_id | UUID | 主键 |
| work_id | UUID | 外键→作品 |
| sequence | INT | 段落序号（从1开始） |
| content | TEXT | 段落内容 |

**对应 JSON 字段**: `paragraphs` 数组

**唯一约束**: (work_id, sequence)

---

### 4.3 tone_patterns (平仄表)

存储每行的平仄格式。

| 字段 | 类型 | 说明 |
|------|------|------|
| pattern_id | UUID | 主键 |
| work_id | UUID | 外键→作品 |
| line_number | INT | 行号 |
| pattern | TEXT | 平仄格式（如"平平仄仄平平仄"） |

**对应 JSON 字段**: `strains` 数组

---

## 五、注释与赏析

### 5.1 work_notes (作品注释表)

存储原始数据中的注释。

| 字段 | 类型 | 说明 |
|------|------|------|
| note_id | UUID | 主键 |
| work_id | UUID | 外键→作品 |
| note_index | INT | 注释序号 |
| note_content | TEXT | 注释内容 |
| note_type | VARCHAR(20) | original/editorial/scholarly |

**对应 JSON 字段**: `notes` 数组

---

### 5.2 annotations (词语注释表)

详细解释特定词语或典故。

| 字段 | 类型 | 说明 |
|------|------|------|
| annotation_id | UUID | 主键 |
| work_id | UUID | 外键→作品 |
| term | VARCHAR(200) | 被注释词语 |
| term_position | INT | 位置 |
| explanation | TEXT | 解释 |
| pronunciation | VARCHAR(100) | 读音/注音 |

---

### 5.3 appreciations (赏析表)

存储作品的鉴赏文章。

| 字段 | 类型 | 说明 |
|------|------|------|
| appreciation_id | UUID | 主键 |
| work_id | UUID | 外键→作品 |
| title | VARCHAR(200) | 赏析标题 |
| content | TEXT | 赏析内容 |
| appreciation_type | VARCHAR(20) | 类型：general/artistic/historical |

---

## 六、标签系统

### 6.1 tags (标签表)

| 字段 | 类型 | 说明 |
|------|------|------|
| tag_id | UUID | 主键 |
| tag_name | VARCHAR(100) | 标签名（唯一） |
| tag_category | VARCHAR(50) | 标签分类（主题/情感/季节等） |
| usage_count | INT | 使用次数（自动更新） |

### 6.2 work_tags (作品标签关联表)

多对多关联表。

| 字段 | 类型 | 说明 |
|------|------|------|
| work_id | UUID | 联合主键，外键→作品 |
| tag_id | UUID | 联合主键，外键→标签 |

---

## 七、视图

### 7.1 v_works_full (作品完整视图)

拼接作品全文内容，包含作者、朝代、类别、词牌信息。

```sql
SELECT work_id, title, author_name, dynasty_name, 
       category_name, rhythmic_name, full_content, ...
FROM v_works_full
WHERE author_name = '苏轼';
```

### 7.2 v_author_stats (作者统计视图)

统计每位作者的作品数量和类别分布。

```sql
SELECT author_name, work_count, categories
FROM v_author_stats
ORDER BY work_count DESC;
```

### 7.3 v_dynasty_stats (朝代统计视图)

统计每个朝代的作者和作品数量。

```sql
SELECT dynasty_name, author_count, work_count
FROM v_dynasty_stats;
```

---

## 八、索引说明

共创建 83 个索引，主要包括：

| 类型 | 数量 | 用途 |
|------|------|------|
| 主键索引 | 19 | 每个表的主键 |
| 外键索引 | 25+ | 加速 JOIN 查询 |
| 唯一索引 | 10+ | 保证数据唯一性 |
| 查询优化索引 | 20+ | 常用字段查询 |
| 复合索引 | 5+ | 多条件查询优化 |

---

## 九、触发器

### 自动更新时间戳

```sql
-- 当记录更新时自动设置 updated_at
CREATE TRIGGER trigger_works_updated_at
    BEFORE UPDATE ON works
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### 标签计数更新

```sql
-- 当添加/删除标签关联时自动更新使用次数
CREATE TRIGGER trigger_work_tags_count
    AFTER INSERT OR DELETE ON work_tags
    FOR EACH ROW EXECUTE FUNCTION update_tag_usage_count();
```

---

## 十、JSON 字段映射参考

| JSON 字段 | 数据库表.字段 | 说明 |
|-----------|--------------|------|
| `author` | works→authors.author_name | 作者姓名 |
| `title` | works.title | 作品标题 |
| `rhythmic` | works→rhythmic_patterns.rhythmic_name | 词牌名 |
| `paragraphs[]` | paragraphs.content | 段落内容 |
| `strains[]` | tone_patterns.pattern | 平仄格式 |
| `notes[]` | work_notes.note_content | 注释内容 |
| `name` | authors.author_name | 作者姓名 |
| `desc` | authors.short_description | 作者简介 |

---

## 十一、常用查询示例

### 查询某作者所有作品

```sql
SELECT w.title, rp.rhythmic_name, 
       string_agg(p.content, E'\n' ORDER BY p.sequence) AS content
FROM works w
JOIN authors a ON w.author_id = a.author_id
LEFT JOIN rhythmic_patterns rp ON w.rhythmic_code = rp.rhythmic_code
LEFT JOIN paragraphs p ON w.work_id = p.work_id
WHERE a.author_name = '李清照'
GROUP BY w.work_id, rp.rhythmic_name;
```

### 按词牌统计作品数

```sql
SELECT rp.rhythmic_name, COUNT(*) AS work_count
FROM works w
JOIN rhythmic_patterns rp ON w.rhythmic_code = rp.rhythmic_code
GROUP BY rp.rhythmic_name
ORDER BY work_count DESC
LIMIT 20;
```

### 搜索包含特定词语的作品

```sql
SELECT w.title, a.author_name, p.content
FROM paragraphs p
JOIN works w ON p.work_id = w.work_id
JOIN authors a ON w.author_id = a.author_id
WHERE p.content LIKE '%明月%';
```
