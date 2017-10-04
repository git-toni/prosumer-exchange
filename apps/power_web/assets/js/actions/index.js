import {attrArrayToMap, attrChangerValue} from './general'
import store from '../store'

//const setNodes = (store)=>{
//  return attrChangerValue.apply(null, store, 'nodes')   
//}
//const setNodes = attrChangerValue(store).bind(null, 'nodes')
const setNodes = attrArrayToMap(store).bind(null, 'nodes')

export {
  setNodes
}

