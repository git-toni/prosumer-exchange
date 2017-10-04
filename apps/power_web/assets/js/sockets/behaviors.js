import {setNodes} from '../actions'
import store from '../store'

let generalBehavior = (socket) =>{
  socket.on('stats',(data)=>{
    //console.log('stats received',data.nodes)
    //store.nodes = Math.random()
    //console.log('datanodes',data.nodes)
    setNodes(data.nodes)
    //generalActions.changeName(data.name)
  })
  //socket.on('alert',(data)=>{
  //  console.log('Receiving alerts:',data)
  //})
  //socket.addEventListener('stats',(data)=>{
  //  console.log('Receiving new stats:',data)
  //  generalActions.changeName('NEWNAME')
  //})
  //socket.addEventListener('alert',(data)=>{
  //  console.log('Receiving alerts:',data)
  //})
  return socket
}

export {
  generalBehavior
}
