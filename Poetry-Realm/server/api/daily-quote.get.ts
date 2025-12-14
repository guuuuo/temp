import { query, queryOne } from '../utils/db'

export default defineEventHandler(async () => {
  const today = new Date()
  const seed = today.getFullYear() * 10000 + (today.getMonth() + 1) * 100 + today.getDate()
  
  const countResult = await queryOne<{ count: string }>(
    `SELECT COUNT(*) as count FROM works WHERE is_featured = true`
  )
  const total = parseInt(countResult?.count || '0')

  if (total === 0) {
    const anyWork = await queryOne(
      `SELECT w.work_id, w.title, w.subtitle,
              a.author_name,
              d.dynasty_name,
              (SELECT string_agg(content, E'\n' ORDER BY sequence) FROM paragraphs p WHERE p.work_id = w.work_id) as content
       FROM works w
       LEFT JOIN authors a ON w.author_id = a.author_id
       LEFT JOIN dynasties d ON w.dynasty_code = d.dynasty_code
       LIMIT 1`
    )
    return anyWork
  }

  const offset = seed % total

  const quote = await queryOne(
    `SELECT w.work_id, w.title, w.subtitle,
            a.author_name, a.author_id,
            d.dynasty_name,
            (SELECT string_agg(content, E'\n' ORDER BY sequence) FROM paragraphs p WHERE p.work_id = w.work_id) as content
     FROM works w
     LEFT JOIN authors a ON w.author_id = a.author_id
     LEFT JOIN dynasties d ON w.dynasty_code = d.dynasty_code
     WHERE w.is_featured = true
     OFFSET $1 LIMIT 1`,
    [offset]
  )

  return quote
})
