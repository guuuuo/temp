import os
import psycopg2
from psycopg2 import sql

def main():
    print("=" * 60)
    print("中国古典诗词文学数据库 Schema 测试")
    print("=" * 60)
    
    database_url = os.environ.get('DATABASE_URL')
    if not database_url:
        print("错误: DATABASE_URL 环境变量未设置")
        return
    
    try:
        conn = psycopg2.connect(database_url)
        cur = conn.cursor()
        print("数据库连接成功!")
        
        print("\n正在执行 Schema...")
        with open('V2__GS_Add_New_Tables_Improved.sql', 'r', encoding='utf-8') as f:
            schema_sql = f.read()
        
        cur.execute(schema_sql)
        conn.commit()
        print("Schema 执行成功!")
        
        print("\n" + "=" * 60)
        print("验证创建的表:")
        print("=" * 60)
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
            ORDER BY table_name
        """)
        tables = cur.fetchall()
        for i, (table,) in enumerate(tables, 1):
            print(f"  {i:2}. {table}")
        print(f"\n共创建 {len(tables)} 个表")
        
        print("\n" + "=" * 60)
        print("验证朝代数据:")
        print("=" * 60)
        cur.execute("SELECT dynasty_code, dynasty_name, start_year, end_year FROM dynasties ORDER BY sequence LIMIT 12")
        for row in cur.fetchall():
            years = f"({row[2] or '?'} - {row[3] or '?'})" if row[2] or row[3] else ""
            print(f"  {row[0]:16} | {row[1]:8} {years}")
        
        print("\n" + "=" * 60)
        print("验证文学类别数据:")
        print("=" * 60)
        cur.execute("SELECT category_code, category_name, parent_code FROM categories ORDER BY sequence LIMIT 15")
        for row in cur.fetchall():
            parent = f"(父类: {row[2]})" if row[2] else ""
            print(f"  {row[0]:15} | {row[1]:8} {parent}")
        
        print("\n" + "=" * 60)
        print("验证视图:")
        print("=" * 60)
        cur.execute("""
            SELECT table_name 
            FROM information_schema.views 
            WHERE table_schema = 'public'
            ORDER BY table_name
        """)
        views = cur.fetchall()
        for (view,) in views:
            print(f"  - {view}")
        print(f"\n共创建 {len(views)} 个视图")
        
        print("\n" + "=" * 60)
        print("验证索引数量:")
        print("=" * 60)
        cur.execute("SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public'")
        index_count = cur.fetchone()[0]
        print(f"  共创建 {index_count} 个索引")
        
        print("\n" + "=" * 60)
        print("Schema 验证完成! 所有测试通过!")
        print("=" * 60)
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print(f"错误: {e}")
        raise

if __name__ == "__main__":
    main()
