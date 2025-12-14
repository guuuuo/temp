import { query } from '../../utils/db'

export default defineEventHandler(async (event) => {
  const queryParams = getQuery(event)
  const page = parseInt(queryParams.page as string) || 1
  const limit = parseInt(queryParams.limit as string) || 20
  const dynasty = queryParams.dynasty as string
  const category = queryParams.category as string
  const author = queryParams.author as string
  const search = queryParams.search as string
  const featured = queryParams.featured === 'true'
  const offset = (page - 1) * limit

  let whereClause = 'WHERE 1=1'
  const params: any[] = []
  let paramIndex = 1

  if (dynasty) {
    whereClause += ` AND w.dynasty_code = $${paramIndex++}`
    params.push(dynasty)
  }

  if (category) {
    whereClause += ` AND (w.category_code = $${paramIndex} OR w.category_code IN (SELECT category_code FROM categories WHERE parent_code = $${paramIndex}))`
    params.push(category)
    paramIndex++
  }

  if (author) {
    whereClause += ` AND w.author_id = $${paramIndex++}`
    params.push(author)
  }

  if (search) {
    whereClause += ` AND (w.title ILIKE $${paramIndex} OR EXISTS (SELECT 1 FROM paragraphs p WHERE p.work_id = w.work_id AND p.content ILIKE $${paramIndex}))`
    params.push(`%${search}%`)
    paramIndex++
  }

  if (featured) {
    whereClause += ` AND w.is_featured = true`
  }

  const countResult = await query<{ count: string }>(
    `SELECT COUNT(*) as count FROM works w ${whereClause}`,
    params
  )
  const total = parseInt(countResult[0]?.count || '0')

  params.push(limit, offset)
  const works = await query(
    `SELECT w.work_id, w.work_code, w.title, w.title_traditional, w.subtitle,
            w.dynasty_code, w.category_code, w.view_count, w.like_count, w.is_featured,
            a.author_id, a.author_name,
            d.dynasty_name,
            c.category_name,
            (SELECT string_agg(content, E'\n' ORDER BY sequence) FROM paragraphs p WHERE p.work_id = w.work_id) as content
     FROM works w
     LEFT JOIN authors a ON w.author_id = a.author_id
     LEFT JOIN dynasties d ON w.dynasty_code = d.dynasty_code
     LEFT JOIN categories c ON w.category_code = c.category_code
     ${whereClause}
     ORDER BY w.is_featured DESC, w.view_count DESC, w.created_at DESC
     LIMIT $${paramIndex++} OFFSET $${paramIndex}`,
    params
  )

  return {
    data: works,
    pagination: {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit)
    }
  }
})
