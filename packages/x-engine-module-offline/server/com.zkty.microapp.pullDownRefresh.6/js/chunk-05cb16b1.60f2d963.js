(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-05cb16b1"],{"1ec6":function(n,t){var s={default:this,call:function(n,t,s){if("function"==typeof t&&(s=t,t={}),t={data:void 0===t?null:t},"function"==typeof s){var o="dscb"+window.dscb++;window[o]=s,t._dscbstub=o}t=JSON.stringify(t);var e="";return window._dsbridge?e=_dsbridge.call(n,t):(window._dswk||-1!=navigator.userAgent.indexOf("_dsbridge"))&&(e=prompt("_dsbridge="+n,t)),JSON.parse(e||"{}").data},register:function(n,t,o){o=o?window._dsaf:window._dsf,window._dsInit||(window._dsInit=!0,setTimeout((function(){s.call("_dsb.dsinit")}),0)),"object"==typeof t?o._obs[n]=t:o[n]=t},registerAsyn:function(n,t){this.register(n,t,!0)},hasNativeMethod:function(n,t){return this.call("_dsb.hasNativeMethod",{name:n,type:t||"all"})},disableJavascriptDialogBlock:function(n){this.call("_dsb.disableJavascriptDialogBlock",{disable:!1!==n})}};(function(){window._dsf||(window["_dsf"]={_obs:{}},window["_dsaf"]={_obs:{}},window["dscb"]=0,window["dsBridge"]=s,window["close"]=function(){s.call("_dsb.closePage")},window["_handleMessageFromNative"]=function(n){var t=JSON.parse(n.data),o={id:n.callbackId,complete:!0},e=this._dsf[n.method],i=this._dsaf[n.method],d=function(n,e){o.data=n.apply(e,t),s.call("_dsb.returnValue",o)},c=function(n,e){t.push((function(n,t){o.data=n,o.complete=!1!==t,s.call("_dsb.returnValue",o)})),n.apply(e,t)};if(e)d(e,this._dsf);else if(i)c(i,this._dsaf);else if(e=n.method.split("."),!(2>e.length)){n=e.pop();e=e.join("."),i=this._dsf._obs,i=i[e]||{};var a=i[n];a&&"function"==typeof a?d(a,i):(i=this._dsaf._obs,i=i[e]||{},(a=i[n])&&"function"==typeof a&&c(a,i))}},s.register("_hasJavascriptMethod",(function(n,t){return t=n.split("."),2>t.length?!(!_dsf[t]&&!_dsaf[t]):(n=t.pop(),t=t.join("."),(t=_dsf._obs[t]||_dsaf._obs[t])&&!!t[n])})))})()},2048:function(n,t){window.xengine=window.xengine||{};const s={toastConfig:{title:"",duration:2e3},showToast:function(n){const t={...this.toastConfig,...n};dsBridge.call("_ui.showToast",JSON.stringify(t),n=>{})},showSuccessToast:function(n){const t={...this.toastConfig,...n};dsBridge.call("_ui.showSuccessToast",JSON.stringify(t),n=>{})},showFailToast:function(n){const t={...this.toastConfig,...n};dsBridge.call("_ui.showFailToast",JSON.stringify(t),n=>{})},hiddenToast:function(n){dsBridge.call("_ui.hiddenToast","",n=>{})},showLoading(){dsBridge.call("_ui.showLoading",null,n=>{})},hideLoading(){dsBridge.call("_ui.hiddenLoading",null,n=>{})},modalConfig:{title:""},showModal:function(n){const t={...this.modalConfig,...n};dsBridge.call("_ui.showModal",JSON.stringify(t),n=>{})},alertConfig:{itemList:["测试1","测试2","测试3","测试4","测试5"]},showActionSheet:function(n){const t={...this.alertConfig,...n};dsBridge.call("_ui.showActionSheet",JSON.stringify(t),n=>{})}};n.exports=s},4739:function(n,t,s){s("1ec6");const o=s("dcaa"),e=s("2048"),i=s("a7e7"),d={};d.network=o,d.pullDownRefresh=i,d.ui=e,n.exports=d},"5ced":function(n,t,s){},"69e5":function(n,t,s){const o=s("4739");n.exports=o},a7e7:function(n,t){window.xengine=window.xengine||{};const s={obj:{},registerOnRefresh(n){this.obj.fn=n},onRefresh(){return new Promise((function(n,t){try{n()}catch(s){t(s)}}))},stopRefresh(n){return new Promise((function(t,s){try{dsBridge.call("com.zkty.module.pullDownRefresh.stopRefresh",s=>{n.hasOwnProperty("success")?n.success(JSON.parse(s)):t(JSON.parse(s))})}catch(o){}}))}};dsBridge.register("onRefresh",n=>{s.obj.fn&&s.obj.fn()}),n.exports=s},bb51:function(n,t,s){"use strict";s.r(t);var o=function(){var n=this,t=n.$createElement,s=n._self._c||t;return s("div",{staticClass:"hello"},[s("p",[n._v("下拉刷新"+n._s(n.count)+"次")])])},e=[],i=s("69e5"),d=s.n(i),c={name:"Home",data:function(){return{count:0}},mounted:function(){this.registerOnRefresh(),console.log(window),console.log(d.a)},methods:{registerOnRefresh:function(){d.a.pullDownRefresh.registerOnRefresh(this.test)},test:function(){console.log("test"),this.count++,d.a.pullDownRefresh.stopRefresh({success:function(n){console.log(n)},fail:function(n){console.log(n)}})}}},a=c,r=(s("cccb"),s("2877")),l=Object(r["a"])(a,o,e,!1,null,null,null);t["default"]=l.exports},cccb:function(n,t,s){"use strict";var o=s("5ced"),e=s.n(o);e.a},dcaa:function(n,t){window.xengine=window.xengine||{};const s={dsBridge:window.dsBridge,requestConfig:{url:"http://127.0.0.1:8000/data0.json",method:"GET"},request:function(n){return new Promise((t,s)=>{try{const s={...this.requestConfig,...n};dsBridge.call("_network.requestNetwork",JSON.stringify(s),(function(n){t(n)}))}catch(o){s(o)}})}};n.exports=s}}]);
//# sourceMappingURL=chunk-05cb16b1.60f2d963.js.map