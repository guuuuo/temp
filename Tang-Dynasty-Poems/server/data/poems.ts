export interface Poem {
  id: string
  title: string
  author: string
  paragraphs: string[]
  tags?: string[]
}

export interface Poet {
  id: string
  name: string
  desc?: string
}

export const samplePoems: Poem[] = [
  {
    id: "1",
    title: "静夜思",
    author: "李白",
    paragraphs: ["床前明月光，", "疑是地上霜。", "举头望明月，", "低头思故乡。"],
    tags: ["思乡", "月亮", "抒情"]
  },
  {
    id: "2",
    title: "春晓",
    author: "孟浩然",
    paragraphs: ["春眠不觉晓，", "处处闻啼鸟。", "夜来风雨声，", "花落知多少。"],
    tags: ["写景", "春天", "抒情"]
  },
  {
    id: "3",
    title: "登鹳雀楼",
    author: "王之涣",
    paragraphs: ["白日依山尽，", "黄河入海流。", "欲穷千里目，", "更上一层楼。"],
    tags: ["写景", "哲理", "登高"]
  },
  {
    id: "4",
    title: "相思",
    author: "王维",
    paragraphs: ["红豆生南国，", "春来发几枝。", "愿君多采撷，", "此物最相思。"],
    tags: ["爱情", "相思", "抒情"]
  },
  {
    id: "5",
    title: "送杜少府之任蜀州",
    author: "王勃",
    paragraphs: ["城阙辅三秦，风烟望五津。", "与君离别意，同是宦游人。", "海内存知己，天涯若比邻。", "无为在歧路，儿女共沾巾。"],
    tags: ["送别", "友情", "抒情"]
  },
  {
    id: "6",
    title: "望庐山瀑布",
    author: "李白",
    paragraphs: ["日照香炉生紫烟，", "遥看瀑布挂前川。", "飞流直下三千尺，", "疑是银河落九天。"],
    tags: ["山水", "写景", "庐山"]
  },
  {
    id: "7",
    title: "江雪",
    author: "柳宗元",
    paragraphs: ["千山鸟飞绝，", "万径人踪灭。", "孤舟蓑笠翁，", "独钓寒江雪。"],
    tags: ["写景", "孤独", "冬天"]
  },
  {
    id: "8",
    title: "枫桥夜泊",
    author: "张继",
    paragraphs: ["月落乌啼霜满天，", "江枫渔火对愁眠。", "姑苏城外寒山寺，", "夜半钟声到客船。"],
    tags: ["羁旅", "思乡", "写景"]
  },
  {
    id: "9",
    title: "黄鹤楼送孟浩然之广陵",
    author: "李白",
    paragraphs: ["故人西辞黄鹤楼，", "烟花三月下扬州。", "孤帆远影碧空尽，", "唯见长江天际流。"],
    tags: ["送别", "友情", "长江"]
  },
  {
    id: "10",
    title: "九月九日忆山东兄弟",
    author: "王维",
    paragraphs: ["独在异乡为异客，", "每逢佳节倍思亲。", "遥知兄弟登高处，", "遍插茱萸少一人。"],
    tags: ["思乡", "重阳", "亲情"]
  },
  {
    id: "11",
    title: "早发白帝城",
    author: "李白",
    paragraphs: ["朝辞白帝彩云间，", "千里江陵一日还。", "两岸猿声啼不住，", "轻舟已过万重山。"],
    tags: ["山水", "抒情", "长江"]
  },
  {
    id: "12",
    title: "悯农",
    author: "李绅",
    paragraphs: ["锄禾日当午，", "汗滴禾下土。", "谁知盘中餐，", "粒粒皆辛苦。"],
    tags: ["农民", "劳动", "哲理"]
  },
  {
    id: "13",
    title: "出塞",
    author: "王昌龄",
    paragraphs: ["秦时明月汉时关，", "万里长征人未还。", "但使龙城飞将在，", "不教胡马度阴山。"],
    tags: ["边塞", "战争", "爱国"]
  },
  {
    id: "14",
    title: "凉州词",
    author: "王翰",
    paragraphs: ["葡萄美酒夜光杯，", "欲饮琵琶马上催。", "醉卧沙场君莫笑，", "古来征战几人回。"],
    tags: ["边塞", "战争", "豪放"]
  },
  {
    id: "15",
    title: "游子吟",
    author: "孟郊",
    paragraphs: ["慈母手中线，游子身上衣。", "临行密密缝，意恐迟迟归。", "谁言寸草心，报得三春晖。"],
    tags: ["母爱", "亲情", "感恩"]
  },
  {
    id: "16",
    title: "赋得古原草送别",
    author: "白居易",
    paragraphs: ["离离原上草，一岁一枯荣。", "野火烧不尽，春风吹又生。", "远芳侵古道，晴翠接荒城。", "又送王孙去，萋萋满别情。"],
    tags: ["送别", "咏物", "草"]
  }
]

export const samplePoets: Poet[] = [
  { id: "1", name: "李白", desc: "字太白，号青莲居士，又号「谪仙人」，唐代伟大的浪漫主义诗人，被后人誉为「诗仙」。" },
  { id: "2", name: "杜甫", desc: "字子美，自号少陵野老，唐代伟大的现实主义诗人，被后人称为「诗圣」。" },
  { id: "3", name: "王维", desc: "字摩诘，号摩诘居士，唐朝著名诗人、画家。诗画双绝，被誉为「诗佛」。" },
  { id: "4", name: "白居易", desc: "字乐天，号香山居士，又号醉吟先生。唐代伟大的现实主义诗人，唐代三大诗人之一。" },
  { id: "5", name: "孟浩然", desc: "字浩然，号孟山人，唐代著名的山水田园派诗人，世称「孟襄阳」。" },
  { id: "6", name: "王昌龄", desc: "字少伯，唐代著名边塞诗人，被后人誉为「七绝圣手」。" },
  { id: "7", name: "柳宗元", desc: "字子厚，唐代著名文学家、哲学家、散文家和思想家，「唐宋八大家」之一。" },
  { id: "8", name: "王勃", desc: "字子安，唐代诗人，「初唐四杰」之首。" },
  { id: "9", name: "王之涣", desc: "字季凌，唐代著名诗人，与王昌龄、高适并称「边塞三诗人」。" },
  { id: "10", name: "孟郊", desc: "字东野，唐代著名诗人，有「诗囚」之称，与贾岛齐名，世称「郊寒岛瘦」。" },
  { id: "11", name: "李绅", desc: "字公垂，唐代诗人，其《悯农》诗流传甚广。" },
  { id: "12", name: "张继", desc: "字懿孙，唐代诗人，其《枫桥夜泊》是脍炙人口的名篇。" }
]

export function getPoems(page = 1, limit = 12, tag?: string, search?: string): { poems: Poem[], total: number } {
  let filtered = [...samplePoems]
  
  if (tag) {
    filtered = filtered.filter(p => p.tags?.includes(tag))
  }
  
  if (search) {
    const q = search.trim()
    filtered = filtered.filter(p => 
      p.title.includes(q) || 
      p.author.includes(q) ||
      p.paragraphs.some(line => line.includes(q))
    )
  }
  
  const validPage = Math.max(1, page)
  const validLimit = Math.max(1, Math.min(100, limit))
  const start = (validPage - 1) * validLimit
  const poems = filtered.slice(start, start + validLimit)
  
  return { poems, total: filtered.length }
}

export function getPoemById(id: string): Poem | undefined {
  return samplePoems.find(p => p.id === id)
}

export function getPoemsByAuthor(author: string): Poem[] {
  return samplePoems.filter(p => p.author === author)
}

export function getPoets(page = 1, limit = 12, search?: string): { poets: Poet[], total: number } {
  let filtered = [...samplePoets]
  
  if (search) {
    const q = search.trim()
    filtered = filtered.filter(p => 
      p.name.includes(q) || 
      p.desc?.includes(q)
    )
  }
  
  const validPage = Math.max(1, page)
  const validLimit = Math.max(1, Math.min(100, limit))
  const start = (validPage - 1) * validLimit
  const poets = filtered.slice(start, start + validLimit)
  
  return { poets, total: filtered.length }
}

export function getPoetByName(name: string): Poet | undefined {
  return samplePoets.find(p => p.name === name)
}
