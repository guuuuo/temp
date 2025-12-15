import { query, queryOne } from '../../utils/db'

export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')

  const work = await queryOne(
    `SELECT w.*, 
            a.author_id, a.author_name, a.author_code, a.short_description as author_description,
            d.dynasty_name,
            c.category_name
     FROM works w
     LEFT JOIN authors a ON w.author_id = a.author_id
     LEFT JOIN dynasties d ON w.dynasty_code = d.dynasty_code
     LEFT JOIN categories c ON w.category_code = c.category_code
     WHERE w.work_id::text = $1 OR w.work_code = $1`,
    [id]
  )

  if (!work) {
    throw createError({
      statusCode: 404,
      message: '作品不存在'
    })
  }

  await query(
    `UPDATE works SET view_count = view_count + 1 WHERE work_id = $1`,
    [work.work_id]
  )

  const paragraphs = await query(
    `SELECT paragraph_id, sequence, content, content_traditional, is_title_line
     FROM paragraphs
     WHERE work_id = $1
     ORDER BY sequence`,
    [work.work_id]
  )

  const annotations = await query(
    `SELECT annotation_id, term, explanation, pronunciation, line_number
     FROM annotations
     WHERE work_id = $1
     ORDER BY line_number, term_position`,
    [work.work_id]
  )

  const appreciations = await query(
    `SELECT appreciation_id, content, author_name, source, appreciation_type
     FROM appreciations
     WHERE work_id = $1`,
    [work.work_id]
  )

  const notes = await query(
    `SELECT note_id, note_index, note_content, note_type
     FROM work_notes
     WHERE work_id = $1
     ORDER BY note_index`,
    [work.work_id]
  )

  return {
    ...work,
    paragraphs,
    annotations,
    appreciations,
    notes
  }
})
