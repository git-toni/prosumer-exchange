const attrChangerValue =(store)=>{
  let changer = (attr,v)=>{
      store[attr] = v
  }
  return changer
}
const attrArrayToMap =(store)=>{
  let changer = (attr,arr)=>{
    //console.log('arr',arr)
    store[attr] = {}
    arr.reduce((map,obj)=>{
      store[attr][obj.id] = obj
    },{})

  }
  return changer
}

export {attrChangerValue, attrArrayToMap}
