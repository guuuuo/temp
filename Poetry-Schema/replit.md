# 中国古典诗词文学数据库 Schema

## 项目概述

这是一个专为存储中国古典诗词文学数据设计的 PostgreSQL 数据库 Schema。它基于 [chinese-poetry](https://github.com/chinese-poetry/chinese-poetry) 开源数据库的数据结构进行了优化和扩展，支持存储从先秦到近代的所有中国古典文学作品。

## 支持的数据源

| 数据源 | 内容 | 预估数量 |
|--------|------|----------|
| 五代诗词 | 花间集、南唐二主词 | ~500首 |
| 全唐诗 | 唐诗全集 | ~55,000首 |
| 宋词 | 宋词全集 | ~21,000首 |
| 元曲 | 元代散曲 | 数千首 |
| 四书五经 | 儒家经典 | 多部 |
| 诗经 | 中国最早诗歌总集 | 305篇 |
| 楚辞 | 屈原等作品 | 数十篇 |
| 蒙学 | 三字经、千字文等 | 多部 |
| 论语 | 孔子言行录 | 20篇 |
| 个人诗集 | 纳兰性德、曹操等 | 数百首 |

## 数据库架构

### 核心表

1. **dynasties** - 朝代表
2. **categories** - 文学类别表
3. **rhythmic_patterns** - 词牌/曲牌表
4. **authors** - 作者表
5. **collections** - 作品集/文集表
6. **chapters** - 章节表
7. **sections** - 小节表
8. **works** - 作品主表
9. **paragraphs** - 段落/诗句表
10. **tone_patterns** - 平仄格式表

### 辅助表

11. **work_notes** - 作品注释表
12. **annotations** - 词语注释表
13. **appreciations** - 赏析表
14. **tags** - 标签表
15. **work_tags** - 作品标签关联表
16. **anecdotes** - 作者轶闻表
17. **author_relationships** - 作者关系表
18. **import_batches** - 导入批次表
19. **import_errors** - 导入错误表

### 视图

- **v_works_full** - 作品完整信息视图
- **v_author_stats** - 作者统计视图
- **v_dynasty_stats** - 朝代统计视图

## 主要改进

相比原版 Schema，本版本改进包括：

### 1. 词牌支持
- 新增 `rhythmic_patterns` 表存储词牌信息
- `works` 表关联词牌，支持宋词、元曲的词牌/曲牌分类

### 2. 平仄格式
- 新增 `tone_patterns` 表存储每行的平仄格式
- 对应 JSON 数据中的 `strains` 字段

### 3. 章节层级
- 新增 `collections`、`chapters`、`sections` 表
- 支持四书五经、诗经等有层级结构的文献

### 4. 作者详情
- 扩展作者信息：字、号、籍贯、官职等
- 支持作者关系（师生、友人等）

### 5. 数据追踪
- 完整的数据来源追踪字段
- 导入批次和错误记录

### 6. 性能优化
- 复合索引优化常用查询
- 唯一性约束保证数据完整性
- 自动更新时间戳触发器

## 使用方法

### 1. 创建数据库

```bash
psql -U postgres -c "CREATE DATABASE chinese_poetry;"
```

### 2. 执行 Schema

```bash
psql -U postgres -d chinese_poetry -f V2__GS_Add_New_Tables_Improved.sql
```

### 3. 验证安装

```sql
-- 查看创建的表
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';

-- 查看朝代数据
SELECT * FROM dynasties ORDER BY sequence;

-- 查看类别数据
SELECT * FROM categories ORDER BY sequence;
```

## 数据导入示例

### Python 示例

```python
import json
import psycopg2
from uuid import uuid4

conn = psycopg2.connect(DATABASE_URL)
cur = conn.cursor()

# 导入宋词
with open('ci.song.0.json', 'r', encoding='utf-8') as f:
    poems = json.load(f)

for poem in poems:
    # 插入作品
    work_id = str(uuid4())
    cur.execute('''
        INSERT INTO works (work_id, title, dynasty_code, source_collection)
        VALUES (%s, %s, 'song', '宋词')
        RETURNING work_id
    ''', (work_id, poem.get('rhythmic', '无题')))
    
    # 插入段落
    for i, para in enumerate(poem.get('paragraphs', []), 1):
        cur.execute('''
            INSERT INTO paragraphs (work_id, sequence, content)
            VALUES (%s, %s, %s)
        ''', (work_id, i, para))

conn.commit()
```

## 文件结构

```
.
├── V2__GS_Add_New_Tables_Improved.sql  # 主 Schema 文件
├── replit.md                            # 项目文档
└── test_schema.py                       # Schema 测试脚本
```

## 版本历史

- **v2.0** (2025-12-13): 完整改进版，支持所有数据源
- **v1.0**: 原始版本

## 许可证

MIT License
