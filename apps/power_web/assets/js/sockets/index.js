import socket from './socket'
import worldConnect from './world-channel'
import {generalBehavior} from './behaviors'

const worldSocket = generalBehavior(worldConnect(socket))
export default worldSocket
export {
  worldSocket
}
