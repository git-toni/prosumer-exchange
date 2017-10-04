import "phoenix_html"

import socket  from './sockets'
import {setNodes} from './actions'
import store from './store'
console.log("Aloha!")


//var mymap = L.map('mapid').setView([51.505, -0.09], 13);
var mymap = L.map('mapid').setView([50.887222, 10.005556], 7);
// Mabbox Dark
//L.tileLayer('https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoidG9uaXUiLCJhIjoiY2o3bjZ5bmRuMnhpYjJxbWoxbGIwMWk3aiJ9.flgQgH61YWCoJD6Vkwk39g', {
//L.tileLayer('//stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.png', {
//L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//L.tileLayer('http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png', {
// B & W
L.tileLayer('//stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.png', {
    maxZoom: 28,
    id: 'mapbox.streets',
    //accessToken: 'your.mapbox.access.token'
}).addTo(mymap);



var polygonLatLngs = [
    [51.509, -0.08],
    [51.503, -0.06],
    [51.51, -0.047],
    [51.509, -0.08]
];
var projectedPolygon;
var triangle = new PIXI.Graphics();

var pixiContainer = new PIXI.Container();

var firstDraw = true;
var prevZoom;
var renderer, stage, project, zoom
var utils 
var screenNodes = {}, prevStoreNodes = {}

let pixiOverlay = L.pixiOverlay((myUtils)=>{
  utils = myUtils
  renderer = utils.getRenderer();
  stage = utils.getContainer();
  project = utils.latLngToLayerPoint;
  zoom = utils.getMap().getZoom();
  //var scale = utils.getScale();
  renderer.view.style.position = "absolute";
  renderer.view.style.display = "block";
  //renderer.backgroundColor = 0x061639;
  renderer.autoResize = true;

  //render(utils)
  gameLoop()

}, pixiContainer)

var texture = PIXI.Texture.fromImage('images/bunny2.png');

let csto, ccon, psto, color,cache, gen, isto
const redToGreen = [0xFF0000, 0xFFFF00, 0xFFFF00, 0x7FFF00, 0x00FF00]

function render(){
  renderer = utils.getRenderer();
  stage = utils.getContainer();
  project = utils.latLngToLayerPoint;
  zoom = utils.getMap().getZoom();

  if(!R.equals(prevStoreNodes,store.nodes)){
    for(let k of Object.keys(store.nodes)){
      let pol = store.nodes[k]
      //var coords = project([pol.x, pol.y])
      var coords = project([pol.lat, pol.lon])
      if(!screenNodes[pol.id]){
        var bunny = PIXI.Sprite.fromImage('images/house-blue.png');
        //var bunny = PIXI.Sprite.fromImage('images/battery-llamp.png');
        bunny.anchor.set(0.5);
        bunny.x = coords.x;
        bunny.y = coords.y;
        bunny.scale.x = 10
        bunny.scale.y = 10
        //bunny.tint = 0xFA3B29
        stage.addChild(bunny);
        screenNodes[pol.id] = bunny
        prevStoreNodes[pol.id] = pol

        // Adding text
        csto = (pol.current_storage/1000).toFixed(2)
        ccon = (pol.consumption/1000).toFixed(2)
        isto = (pol.installed_storage/1000).toFixed(2)
        psto = Math.round((csto/isto)*100)
        color = Math.floor(psto/20.0)
        //psto = Math.round((csto/pol.installed_storage)*100)
        cache = (pol.cache/1000).toFixed(2)
        gen = (pol.current_generation/1000).toFixed(2)
        //bunny.tint = redToGreen[color]
        let cont = `Consumption: ${ccon} kW 
        \n Generation: ${gen} kW) 
        \n Storage: %(${csto} kWh) 
        \n Cache: ${cache} kWh`
        let text = new PIXI.Text(cont,{fontFamily : 'Arial', 
                                 fontSize: 24, 
                                 fill : 0xff1010, 
                                 align : 'center'});
        text.x = coords.x
        text.y = coords.y
        text.scale.x = 10
        text.scale.y = 10
        stage.addChild(text)
        screenNodes[pol.id].text = text


      }
      else{
        csto = (pol.current_storage/1000).toFixed(2)
        ccon = (pol.consumption/1000).toFixed(2)
        isto = (pol.installed_storage/1000).toFixed(2)
        //psto = Math.round((csto/pol.installed_storage)*100)
        psto = Math.round((csto/isto)*100)
        cache = (pol.cache/1000).toFixed(2)
        gen = (pol.current_generation/1000).toFixed(2)
        screenNodes[pol.id].x = coords.x
        screenNodes[pol.id].y = coords.y
        screenNodes[pol.id].text.text = `Consumption: ${ccon} kW \n 
        Generation: ${gen} kW  \n
        Storage: ${psto}%(${csto} kWh) \n 
        Cache: ${cache} kWh`
        prevStoreNodes[pol.id] = pol
      }
    };
  }
  //firstDraw = false;
  prevZoom = zoom;
  //console.log('painting')
  renderer.render(stage);
}

//function gameLoop(renderer,stage){
function gameLoop(){
  render()
  //updateGame()
  setTimeout(gameLoop,1000)
}

pixiOverlay.addTo(mymap);
