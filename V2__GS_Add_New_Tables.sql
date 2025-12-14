-- ============================================================================
-- 中国古典诗词文学数据库 - 改进版 Schema
-- Chinese Classical Poetry & Literature Database - Improved Schema
-- Version: 2.0
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 第一部分: 基础参考表
-- ============================================================================

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

CREATE INDEX idx_dynasties_name ON dynasties(dynasty_name);
CREATE INDEX idx_dynasties_sequence ON dynasties(sequence);

CREATE TABLE categories (
                            category_code VARCHAR(50) PRIMARY KEY,
                            category_name VARCHAR(100) NOT NULL UNIQUE,
                            parent_code VARCHAR(50) REFERENCES categories(category_code),
                            description TEXT,
                            sequence INT DEFAULT 0,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_categories_name ON categories(category_name);
CREATE INDEX idx_categories_parent ON categories(parent_code);

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

CREATE INDEX idx_rhythmic_name ON rhythmic_patterns(rhythmic_name);
CREATE INDEX idx_rhythmic_type ON rhythmic_patterns(poetry_type);

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
                         CONSTRAINT unique_author_code UNIQUE(author_code)
);

CREATE INDEX idx_authors_code ON authors(author_code);
CREATE INDEX idx_authors_name ON authors(author_name);
CREATE INDEX idx_authors_dynasty ON authors(dynasty_code);

-- ============================================================================
-- 第三部分: 作品集/文集表
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

CREATE INDEX idx_collections_code ON collections(collection_code);
CREATE INDEX idx_collections_name ON collections(collection_name);
CREATE INDEX idx_collections_category ON collections(category_code);

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

CREATE INDEX idx_chapters_collection ON chapters(collection_id);
CREATE INDEX idx_chapters_sequence ON chapters(sequence);

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

CREATE INDEX idx_works_code ON works(work_code);
CREATE INDEX idx_works_title ON works(title);
CREATE INDEX idx_works_author ON works(author_id);
CREATE INDEX idx_works_dynasty ON works(dynasty_code);
CREATE INDEX idx_works_category ON works(category_code);
CREATE INDEX idx_works_rhythmic ON works(rhythmic_code);
CREATE INDEX idx_works_collection ON works(collection_id);
CREATE INDEX idx_works_source ON works(source_collection);
CREATE INDEX idx_works_import_batch ON works(import_batch_id);

-- ============================================================================
-- 第五部分: 作品内容表
-- ============================================================================

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

CREATE INDEX idx_paragraphs_work ON paragraphs(work_id);
CREATE INDEX idx_paragraphs_sequence ON paragraphs(work_id, sequence);

CREATE TABLE tone_patterns (
                               pattern_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                               work_id UUID NOT NULL REFERENCES works(work_id) ON DELETE CASCADE,
                               line_number INT NOT NULL,
                               pattern TEXT NOT NULL,
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               CONSTRAINT unique_tone_pattern UNIQUE(work_id, line_number)
);

CREATE INDEX idx_tone_patterns_work ON tone_patterns(work_id);

-- ============================================================================
-- 第六部分: 注释与赏析
-- ============================================================================

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

CREATE INDEX idx_work_notes_work ON work_notes(work_id);

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

CREATE INDEX idx_annotations_work ON annotations(work_id);
CREATE INDEX idx_annotations_term ON annotations(term);

CREATE TABLE appreciations (
                               appreciation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                               work_id UUID NOT NULL REFERENCES works(work_id) ON DELETE CASCADE,
                               content TEXT NOT NULL,
                               author_name VARCHAR(100),
                               source VARCHAR(200),
                               appreciation_type VARCHAR(20) DEFAULT 'general'
                                   CHECK (appreciation_type IN ('general', 'artistic', 'historical', 'linguistic')),
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_appreciations_work ON appreciations(work_id);

-- ============================================================================
-- 第七部分: 批次导入跟踪表
-- ============================================================================

CREATE TABLE import_batches (
                                batch_id VARCHAR(50) PRIMARY KEY,
                                source_collection VARCHAR(100) NOT NULL,
                                source_directory VARCHAR(500),
                                started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                completed_at TIMESTAMP,
                                status VARCHAR(20) DEFAULT 'running'
                                    CHECK (status IN ('running', 'completed', 'failed', 'cancelled')),
                                total_files INT DEFAULT 0,
                                processed_files INT DEFAULT 0,
                                total_records INT DEFAULT 0,
                                inserted_records INT DEFAULT 0,
                                updated_records INT DEFAULT 0,
                                skipped_records INT DEFAULT 0,
                                error_count INT DEFAULT 0,
                                error_messages TEXT,
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_import_batches_source ON import_batches(source_collection);
CREATE INDEX idx_import_batches_status ON import_batches(status);