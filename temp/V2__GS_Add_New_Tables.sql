-- 创建扩展以支持UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 创建朝代表
CREATE TABLE Dynasties (
                           dynasty_code VARCHAR(20) PRIMARY KEY,
                           dynasty_name VARCHAR(20) NOT NULL,
                           start_year INT,
                           end_year INT,
                           introduction TEXT,
                           sequence INT NOT NULL
);

-- 创建索引以优化查询
CREATE INDEX idx_dynasties_dynasty_name ON Dynasties (dynasty_name);

-- 创建作者表
CREATE TABLE Authors (
                         author_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                         author_code VARCHAR(100) NOT NULL,
                         author_name VARCHAR(100) NOT NULL,
                         dynasty_code VARCHAR(20) REFERENCES Dynasties(dynasty_code),
                         birth_year INT,
                         death_year INT,
                         biography TEXT,
                         life_story TEXT,
                         achievements TEXT,
                         avatar_path TEXT
);

-- 创建索引以优化查询
CREATE INDEX idx_authors_author_code ON Authors (author_code);
CREATE INDEX idx_authors_author_name ON Authors (author_name);
CREATE INDEX idx_authors_dynasty_code ON Authors (dynasty_code);

-- 创建类别表
CREATE TABLE Categories (
                            category_code VARCHAR(50) PRIMARY KEY,
                            category_name VARCHAR(50) NOT NULL
);

-- 创建索引以优化查询
CREATE INDEX idx_categories_category_name ON Categories (category_name);

-- 创建作品表
CREATE TABLE Works (
                       work_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                       title VARCHAR(200) NOT NULL,
                       author_id UUID REFERENCES Authors(author_id),
                       dynasty_code VARCHAR(20) REFERENCES Dynasties(dynasty_code),
                       category_code VARCHAR(50) REFERENCES Categories(category_code),
                       content TEXT NOT NULL,
                       description TEXT,
                       description_reference TEXT,
                       introduction TEXT,
                       introduction_reference TEXT,
                       translation TEXT,
                       translation_reference TEXT
);

-- 创建索引以优化查询
CREATE INDEX idx_works_title ON Works (title);
CREATE INDEX idx_works_author_id ON Works (author_id);
CREATE INDEX idx_works_dynasty_code ON Works (dynasty_code);
CREATE INDEX idx_works_category_code ON Works (category_code);

-- 创建作品内容
CREATE TABLE Paragraphs (
                            paragraph_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                            work_id UUID REFERENCES Works(work_id),
                            sequence INT NOT NULL,
                            content TEXT NOT NULL
);

-- 创建索引以优化查询
CREATE INDEX idx_paragraphs_work_id ON Paragraphs (work_id);
CREATE INDEX idx_paragraphs_sequence ON Paragraphs (sequence);

-- 创建标签表
CREATE TABLE Tags (
                      tag_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                      tag_name VARCHAR(50) NOT NULL
);

-- 创建索引以优化查询
CREATE INDEX idx_tags_tag_name ON Tags (tag_name);

-- 创建作品-标签关系表
CREATE TABLE WorkTags (
                          work_id UUID REFERENCES Works(work_id),
                          tag_id UUID REFERENCES Tags(tag_id),
                          PRIMARY KEY (work_id, tag_id)
);

-- 创建索引以优化查询
CREATE INDEX idx_worktags_work_id ON WorkTags (work_id);
CREATE INDEX idx_worktags_tag_id ON WorkTags (tag_id);

-- 创建注释表
CREATE TABLE Annotations (
                             annotation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                             work_id UUID REFERENCES Works(work_id),
                             term VARCHAR(100) NOT NULL,
                             explanation TEXT NOT NULL,
                             reference TEXT
);

-- 创建索引以优化查询
CREATE INDEX idx_annotations_work_id ON Annotations (work_id);
CREATE INDEX idx_annotations_term ON Annotations (term);

-- 创建赏析表
CREATE TABLE Appreciations (
                               appreciation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                               work_id UUID REFERENCES Works(work_id),
                               content TEXT NOT NULL,
                               reference TEXT
);

-- 创建索引以优化查询
CREATE INDEX idx_appreciations_work_id ON Appreciations (work_id);

-- 创建轶闻表
CREATE TABLE Anecdotes (
                           anecdote_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                           author_id UUID REFERENCES Authors(author_id),
                           content TEXT NOT NULL,
                           reference TEXT
);

-- 创建索引以优化查询
CREATE INDEX idx_anecdotes_author_id ON Anecdotes (author_id);
