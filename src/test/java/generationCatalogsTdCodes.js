function generationCatalogsTdCodes(count) {
  result = [];
  for(idx = 0; idx < count; idx++){
    result.push(Math.floor((Math.random() * 100000) + 1) + idx)
  }
  return result;
}