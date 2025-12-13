import { getPoems } from '../data/poems'

export default defineEventHandler((event) => {
  const query = getQuery(event)
  const page = parseInt(query.page as string) || 1
  const limit = parseInt(query.limit as string) || 12
  const tag = query.tag as string | undefined
  const search = query.q as string | undefined
  
  return getPoems(page, limit, tag, search)
})
