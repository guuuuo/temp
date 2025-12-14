import { query } from '../utils/db'

export default defineEventHandler(async () => {
  const categories = await query(`
    SELECT c.category_code, c.category_name, c.parent_code, c.description, c.sequence,
           (SELECT COUNT(*) FROM works w WHERE w.category_code = c.category_code) as work_count
    FROM categories c
    ORDER BY c.sequence
  `)
  return categories
})
