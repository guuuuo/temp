import { getPoetByName, getPoemsByAuthor } from '../../data/poems'

export default defineEventHandler((event) => {
  const name = decodeURIComponent(getRouterParam(event, 'name') || '')
  
  if (!name) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Poet name is required'
    })
  }
  
  const poet = getPoetByName(name)
  
  if (!poet) {
    throw createError({
      statusCode: 404,
      statusMessage: 'Poet not found'
    })
  }
  
  const poems = getPoemsByAuthor(name)
  
  return { poet, poems }
})
