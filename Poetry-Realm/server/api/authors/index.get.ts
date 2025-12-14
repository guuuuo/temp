import { query } from '../../utils/db'

export default defineEventHandler(async (event) => {
  const queryParams = getQuery(event)
  const page = parseInt(queryParams.page as string) || 1
  const limit = parseInt(queryParams.limit as string) || 20
  const dynasty = queryParams.dynasty as string
  const search = queryParams.search as string
  const offset = (page - 1) * limit

  let whereClause = 'WHERE 1=1'
  const params: any[] = []
  let paramIndex = 1

  if (dynasty) {
    whereClause += ` AND a.dynasty_code = $${paramIndex++}`
    params.push(dynasty)
  }

  if (search) {
    whereClause += ` AND (a.author_name ILIKE $${paramIndex} OR a.courtesy_name ILIKE $${paramIndex})`
    params.push(`%${search}%`)
    paramIndex++
  }

  const countResult = await query<{ count: string }>(
    `SELECT COUNT(*) as count FROM authors a ${whereClause}`,
    params
  )
  const total = parseInt(countResult[0]?.count || '0')

  params.push(limit, offset)
  const authors = await query(
    `SELECT a.author_id, a.author_code, a.author_name, a.author_name_traditional,
            a.courtesy_name, a.pseudonym, a.dynasty_code, a.birth_year, a.death_year,
            a.short_description, a.birthplace,
            d.dynasty_name,
            (SELECT COUNT(*) FROM works w WHERE w.author_id = a.author_id) as work_count
     FROM authors a
     LEFT JOIN dynasties d ON a.dynasty_code = d.dynasty_code
     ${whereClause}
     ORDER BY d.sequence, a.author_name
     LIMIT $${paramIndex++} OFFSET $${paramIndex}`,
    params
  )

  return {
    data: authors,
    pagination: {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit)
    }
  }
})
