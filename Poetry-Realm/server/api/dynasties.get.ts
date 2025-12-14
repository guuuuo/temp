import { query } from '../utils/db'

export default defineEventHandler(async () => {
  const dynasties = await query(`
    SELECT dynasty_code, dynasty_name, dynasty_name_traditional, start_year, end_year, sequence
    FROM dynasties
    WHERE dynasty_code != 'unknown'
    ORDER BY sequence
  `)
  return dynasties
})
