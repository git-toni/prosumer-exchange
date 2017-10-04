//import {generalBehavior} from './behaviors'

let worldChannel = (socket) =>{
  let chan = socket.channel('world:main')
  chan.join()
    .receive("ok", resp => console.log("joined the world channel", resp) )
    .receive("error", resp => console.log("Error joining world channel", resp))
  return chan
}

export default worldChannel
