import { getPoemById } from '../../data/poems'

export default defineEventHandler((event) => {
  const id = getRouterParam(event, 'id')
  
  if (!id) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Poem ID is required'
    })
  }
  
  const poem = getPoemById(id)
  
  if (!poem) {
    throw createError({
      statusCode: 404,
      statusMessage: 'Poem not found'
    })
  }
  
  return poem
})
