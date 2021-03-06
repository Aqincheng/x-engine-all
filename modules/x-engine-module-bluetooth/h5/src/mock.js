
// MODIFIALBE! 
// generated by api_generator.js,
// only generated when file is not existed!

export default {

    
    initBluetooth(args={
          "__event__": null
},userPromise){
      if(userPromise){
        return userPromise()
      }else{
        return new Promise((resolve, reject)=>{
          alert("initBluetooth no h5 implementation, you can implement this function in mock.js in  h5/src/mock.js");
          resolve(null);
        });
      }

    }
    ,
    
    scanBluetoothDevice(args={
          "__event__": null
},userPromise){
      if(userPromise){
        return userPromise()
      }else{
        return new Promise((resolve, reject)=>{
          alert("scanBluetoothDevice no h5 implementation, you can implement this function in mock.js in  h5/src/mock.js");
          resolve(null);
        });
      }

    }
    ,
    
    closeBluetoothDevice(args={},userPromise){
      if(userPromise){
        return userPromise()
      }else{
        return new Promise((resolve, reject)=>{
          alert("closeBluetoothDevice no h5 implementation, you can implement this function in mock.js in  h5/src/mock.js");
          resolve(null);
        });
      }

    }
    ,
    
    linkBluetoothDevice(args={
          "deviceID": "9E7A382F-1BBD-2431-D7B5-6415DDA4BEFB",
          "__event__": null
},userPromise){
      if(userPromise){
        return userPromise()
      }else{
        return new Promise((resolve, reject)=>{
          alert("linkBluetoothDevice no h5 implementation, you can implement this function in mock.js in  h5/src/mock.js");
          resolve(null);
        });
      }

    }
    ,
    
    cancelLinkBluetoothDevice(args={
          "deviceID": "9E7A382F-1BBD-2431-D7B5-6415DDA4BEFB",
          "__event__": null
},userPromise){
      if(userPromise){
        return userPromise()
      }else{
        return new Promise((resolve, reject)=>{
          alert("cancelLinkBluetoothDevice no h5 implementation, you can implement this function in mock.js in  h5/src/mock.js");
          resolve(null);
        });
      }

    }
    ,
    
    discoverServices(args={
          "deviceID": "9E7A382F-1BBD-2431-D7B5-6415DDA4BEFB",
          "__event__": null
},userPromise){
      if(userPromise){
        return userPromise()
      }else{
        return new Promise((resolve, reject)=>{
          alert("discoverServices no h5 implementation, you can implement this function in mock.js in  h5/src/mock.js");
          resolve(null);
        });
      }

    }
    ,
    
    discoverCharacteristics(args={
          "deviceID": "1A5D368E-68E3-069F-D963-E3781097CCD1",
          "serviceId": "FFF0",
          "__event__": null
},userPromise){
      if(userPromise){
        return userPromise()
      }else{
        return new Promise((resolve, reject)=>{
          alert("discoverCharacteristics no h5 implementation, you can implement this function in mock.js in  h5/src/mock.js");
          resolve(null);
        });
      }

    }
    ,
    
    writeValueForCharacteristic(args={
          "characteristicId": "FFF1",
          "__event__": null
},userPromise){
      if(userPromise){
        return userPromise()
      }else{
        return new Promise((resolve, reject)=>{
          alert("writeValueForCharacteristic no h5 implementation, you can implement this function in mock.js in  h5/src/mock.js");
          resolve(null);
        });
      }

    }
    ,
    
    readCharacteristic(args={
          "characteristicId": "FFF1",
          "__event__": null
},userPromise){
      if(userPromise){
        return userPromise()
      }else{
        return new Promise((resolve, reject)=>{
          alert("readCharacteristic no h5 implementation, you can implement this function in mock.js in  h5/src/mock.js");
          resolve(null);
        });
      }

    }
    
}
