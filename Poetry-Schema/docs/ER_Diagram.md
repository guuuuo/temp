# 中国古典诗词文学数据库 - ER 图

## 实体关系图 (Mermaid)

```mermaid
erDiagram
    %% ============================================
    %% 核心实体
    %% ============================================
    
    DYNASTIES {
        varchar dynasty_code PK "朝代代码"
        varchar dynasty_name "朝代名称"
        varchar dynasty_name_traditional "繁体名称"
        int start_year "起始年份"
        int end_year "结束年份"
        text introduction "简介"
        int sequence "排序"
    }
    
    AUTHORS {
        uuid author_id PK "作者ID"
        varchar author_code UK "作者代码"
        varchar author_name "作者姓名"
        varchar courtesy_name "字"
        varchar pseudonym "号"
        varchar dynasty_code FK "朝代"
        int birth_year "生年"
        int death_year "卒年"
        varchar birthplace "籍贯"
        text short_description "简述"
        text biography "生平"
    }
    
    CATEGORIES {
        varchar category_code PK "类别代码"
        varchar category_name UK "类别名称"
        varchar parent_code FK "父类别"
        text description "描述"
        int sequence "排序"
    }
    
    RHYTHMIC_PATTERNS {
        varchar rhythmic_code PK "词牌代码"
        varchar rhythmic_name "词牌名"
        varchar poetry_type "类型(词/曲)"
        int line_count "行数"
        text tone_pattern "平仄格式"
        text rhyme_scheme "押韵规则"
    }
    
    %% ============================================
    %% 作品相关
    %% ============================================
    
    COLLECTIONS {
        uuid collection_id PK "文集ID"
        varchar collection_code UK "文集代码"
        varchar collection_name "文集名称"
        varchar category_code FK "类别"
        varchar dynasty_code FK "朝代"
        uuid author_id FK "作者"
    }
    
    CHAPTERS {
        uuid chapter_id PK "章ID"
        uuid collection_id FK "所属文集"
        int chapter_number "章号"
        varchar chapter_title "章标题"
        text chapter_content "章内容"
        int sequence "排序"
    }
    
    SECTIONS {
        uuid section_id PK "节ID"
        uuid chapter_id FK "所属章"
        int section_number "节号"
        varchar section_title "节标题"
        text section_content "节内容"
    }
    
    WORKS {
        uuid work_id PK "作品ID"
        varchar work_code "作品代码"
        varchar title "标题"
        uuid author_id FK "作者"
        varchar dynasty_code FK "朝代"
        varchar category_code FK "类别"
        varchar rhythmic_code FK "词牌"
        uuid collection_id FK "所属文集"
        uuid chapter_id FK "所属章"
        text preface "序言"
        text translation "翻译"
        varchar source_collection "来源"
    }
    
    PARAGRAPHS {
        uuid paragraph_id PK "段落ID"
        uuid work_id FK "作品"
        int sequence "序号"
        text content "内容"
    }
    
    TONE_PATTERNS {
        uuid pattern_id PK "格式ID"
        uuid work_id FK "作品"
        int line_number "行号"
        text pattern "平仄格式"
    }
    
    %% ============================================
    %% 注释与赏析
    %% ============================================
    
    WORK_NOTES {
        uuid note_id PK "注释ID"
        uuid work_id FK "作品"
        int note_index "序号"
        text note_content "注释内容"
        varchar note_type "类型"
    }
    
    ANNOTATIONS {
        uuid annotation_id PK "注解ID"
        uuid work_id FK "作品"
        varchar term "词语"
        text explanation "解释"
        varchar pronunciation "读音"
    }
    
    APPRECIATIONS {
        uuid appreciation_id PK "赏析ID"
        uuid work_id FK "作品"
        varchar title "标题"
        text content "内容"
        varchar appreciation_type "类型"
    }
    
    %% ============================================
    %% 标签系统
    %% ============================================
    
    TAGS {
        uuid tag_id PK "标签ID"
        varchar tag_name UK "标签名"
        varchar tag_category "分类"
        int usage_count "使用次数"
    }
    
    WORK_TAGS {
        uuid work_id PK,FK "作品"
        uuid tag_id PK,FK "标签"
    }
    
    %% ============================================
    %% 作者相关
    %% ============================================
    
    ANECDOTES {
        uuid anecdote_id PK "轶闻ID"
        uuid author_id FK "作者"
        varchar title "标题"
        text content "内容"
        varchar source "来源"
    }
    
    AUTHOR_RELATIONSHIPS {
        uuid relationship_id PK "关系ID"
        uuid author_id_1 FK "作者1"
        uuid author_id_2 FK "作者2"
        varchar relationship_type "关系类型"
    }
    
    %% ============================================
    %% 关系定义
    %% ============================================
    
    DYNASTIES ||--o{ AUTHORS : "belongs_to"
    DYNASTIES ||--o{ WORKS : "belongs_to"
    DYNASTIES ||--o{ COLLECTIONS : "belongs_to"
    
    CATEGORIES ||--o{ CATEGORIES : "parent_of"
    CATEGORIES ||--o{ WORKS : "categorizes"
    CATEGORIES ||--o{ COLLECTIONS : "categorizes"
    
    RHYTHMIC_PATTERNS ||--o{ WORKS : "uses"
    
    AUTHORS ||--o{ WORKS : "writes"
    AUTHORS ||--o{ COLLECTIONS : "authors"
    AUTHORS ||--o{ ANECDOTES : "has"
    AUTHORS ||--o{ AUTHOR_RELATIONSHIPS : "relates"
    
    COLLECTIONS ||--o{ CHAPTERS : "contains"
    COLLECTIONS ||--o{ WORKS : "includes"
    
    CHAPTERS ||--o{ SECTIONS : "contains"
    CHAPTERS ||--o{ WORKS : "includes"
    
    WORKS ||--o{ PARAGRAPHS : "contains"
    WORKS ||--o{ TONE_PATTERNS : "has"
    WORKS ||--o{ WORK_NOTES : "has"
    WORKS ||--o{ ANNOTATIONS : "has"
    WORKS ||--o{ APPRECIATIONS : "has"
    WORKS ||--o{ WORK_TAGS : "tagged"
    
    TAGS ||--o{ WORK_TAGS : "tags"
```

## 简化版关系图

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              基础参考表                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌───────────────────┐             │
│  │  DYNASTIES   │    │  CATEGORIES  │    │ RHYTHMIC_PATTERNS │             │
│  │   (朝代)     │    │   (类别)     │    │     (词牌)        │             │
│  └──────┬───────┘    └──────┬───────┘    └─────────┬─────────┘             │
│         │                   │                      │                        │
└─────────┼───────────────────┼──────────────────────┼────────────────────────┘
          │                   │                      │
          ▼                   ▼                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              核心实体                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────┐                      ┌──────────────┐                    │
│  │   AUTHORS    │◄────────────────────►│    WORKS     │                    │
│  │   (作者)     │     writes           │   (作品)     │                    │
│  └──────┬───────┘                      └──────┬───────┘                    │
│         │                                     │                             │
│         │                    ┌────────────────┼────────────────┐           │
│         ▼                    ▼                ▼                ▼           │
│  ┌──────────────┐    ┌──────────────┐ ┌──────────────┐ ┌──────────────┐   │
│  │  ANECDOTES   │    │  PARAGRAPHS  │ │ TONE_PATTERNS│ │  WORK_NOTES  │   │
│  │   (轶闻)     │    │   (段落)     │ │   (平仄)     │ │   (注释)     │   │
│  └──────────────┘    └──────────────┘ └──────────────┘ └──────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              层级结构 (四书五经等)                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                  │
│  │ COLLECTIONS  │───►│   CHAPTERS   │───►│   SECTIONS   │                  │
│  │   (文集)     │    │    (章)      │    │    (节)      │                  │
│  └──────────────┘    └──────────────┘    └──────────────┘                  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              标签与赏析                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                  │
│  │     TAGS     │◄──►│  WORK_TAGS   │◄──►│    WORKS     │                  │
│  │    (标签)    │    │  (关联表)    │    │              │                  │
│  └──────────────┘    └──────────────┘    └──────┬───────┘                  │
│                                                  │                          │
│                      ┌──────────────┬────────────┘                          │
│                      ▼              ▼                                       │
│              ┌──────────────┐ ┌──────────────┐                             │
│              │ ANNOTATIONS  │ │APPRECIATIONS │                             │
│              │   (词注)     │ │   (赏析)     │                             │
│              └──────────────┘ └──────────────┘                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 数据流向图

```
                    JSON 数据源
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
   ┌─────────┐    ┌─────────┐    ┌─────────┐
   │ 全唐诗  │    │  宋词   │    │四书五经 │
   │poet.*.json│  │ci.*.json│   │ *.json  │
   └────┬────┘    └────┬────┘    └────┬────┘
        │              │              │
        ▼              ▼              ▼
   ┌─────────────────────────────────────────┐
   │           IMPORT_BATCHES                │
   │            (导入批次)                    │
   └─────────────────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
   ┌─────────┐ ┌─────────┐ ┌─────────┐
   │ AUTHORS │ │  WORKS  │ │RHYTHMIC │
   │         │ │         │ │PATTERNS │
   └─────────┘ └────┬────┘ └─────────┘
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
   ┌─────────┐ ┌─────────┐ ┌─────────┐
   │PARAGRAPHS│ │  NOTES │ │TONE_PAT │
   └─────────┘ └─────────┘ └─────────┘
```

## 渲染说明

要渲染 Mermaid 图表，您可以：

1. **GitHub**: 直接在 GitHub 上查看此文件，会自动渲染
2. **VS Code**: 安装 "Markdown Preview Mermaid Support" 扩展
3. **在线工具**: 使用 https://mermaid.live/ 粘贴代码渲染
4. **导出图片**: 使用 mermaid-cli 工具生成 PNG/SVG
