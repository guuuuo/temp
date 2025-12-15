import { query, queryOne } from '../../utils/db'

export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')

  const author = await queryOne(
    `SELECT a.*, d.dynasty_name
     FROM authors a
     LEFT JOIN dynasties d ON a.dynasty_code = d.dynasty_code
     WHERE a.author_id::text = $1 OR a.author_code = $1`,
    [id]
  )

  if (!author) {
    throw createError({
      statusCode: 404,
      message: '作者不存在'
    })
  }

  const works = await query(
    `SELECT w.work_id, w.title, w.subtitle, c.category_name,
            (SELECT content FROM paragraphs p WHERE p.work_id = w.work_id ORDER BY sequence LIMIT 1) as first_line
     FROM works w
     LEFT JOIN categories c ON w.category_code = c.category_code
     WHERE w.author_id = $1
     ORDER BY w.created_at DESC
     LIMIT 20`,
    [author.author_id]
  )

  return { ...author, works }
})
