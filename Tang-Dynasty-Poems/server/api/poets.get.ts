import { getPoets } from '../data/poems'

export default defineEventHandler((event) => {
  const query = getQuery(event)
  const page = parseInt(query.page as string) || 1
  const limit = parseInt(query.limit as string) || 12
  const search = query.q as string | undefined
  
  return getPoets(page, limit, search)
})
