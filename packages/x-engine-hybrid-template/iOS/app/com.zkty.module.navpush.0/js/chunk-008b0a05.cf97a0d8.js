(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-008b0a05"],{"1ec6":function(t,n){var i={default:this,call:function(t,n,i){if("function"==typeof n&&(i=n,n={}),n={data:void 0===n?null:n},"function"==typeof i){var o="dscb"+window.dscb++;window[o]=i,n._dscbstub=o}n=JSON.stringify(n);var a="";return window._dsbridge?a=_dsbridge.call(t,n):(window._dswk||-1!=navigator.userAgent.indexOf("_dsbridge"))&&(a=prompt("_dsbridge="+t,n)),JSON.parse(a||"{}").data},register:function(t,n,o){o=o?window._dsaf:window._dsf,window._dsInit||(window._dsInit=!0,setTimeout((function(){i.call("_dsb.dsinit")}),0)),"object"==typeof n?o._obs[t]=n:o[t]=n},registerAsyn:function(t,n){this.register(t,n,!0)},hasNativeMethod:function(t,n){return this.call("_dsb.hasNativeMethod",{name:t,type:n||"all"})},disableJavascriptDialogBlock:function(t){this.call("_dsb.disableJavascriptDialogBlock",{disable:!1!==t})}};(function(){window._dsf||(window["_dsf"]={_obs:{}},window["_dsaf"]={_obs:{}},window["dscb"]=0,window["dsBridge"]=i,window["close"]=function(){i.call("_dsb.closePage")},window["_handleMessageFromNative"]=function(t){var n=JSON.parse(t.data),o={id:t.callbackId,complete:!0},a=this._dsf[t.method],s=this._dsaf[t.method],e=function(t,a){o.data=t.apply(a,n),i.call("_dsb.returnValue",o)},c=function(t,a){n.push((function(t,n){o.data=t,o.complete=!1!==n,i.call("_dsb.returnValue",o)})),t.apply(a,n)};if(a)e(a,this._dsf);else if(s)c(s,this._dsaf);else if(a=t.method.split("."),!(2>a.length)){t=a.pop();a=a.join("."),s=this._dsf._obs,s=s[a]||{};var d=s[t];d&&"function"==typeof d?e(d,s):(s=this._dsaf._obs,s=s[a]||{},(d=s[t])&&"function"==typeof d&&c(d,s))}},i.register("_hasJavascriptMethod",(function(t,n){return n=t.split("."),2>n.length?!(!_dsf[n]&&!_dsaf[n]):(t=n.pop(),n=n.join("."),(n=_dsf._obs[n]||_dsaf._obs[n])&&!!n[t])})))})()},2048:function(t,n){window.xengine=window.xengine||{};const i={toastConfig:{title:"",duration:2e3},showToast:function(t){const n={...this.toastConfig,...t};dsBridge.call("_ui.showToast",JSON.stringify(n),t=>{})},showSuccessToast:function(t){const n={...this.toastConfig,...t};dsBridge.call("_ui.showSuccessToast",JSON.stringify(n),t=>{})},showFailToast:function(t){const n={...this.toastConfig,...t};dsBridge.call("_ui.showFailToast",JSON.stringify(n),t=>{})},hiddenToast:function(t){dsBridge.call("_ui.hiddenToast","",t=>{})},showLoading(){dsBridge.call("_ui.showLoading",null,t=>{})},hideLoading(){dsBridge.call("_ui.hiddenLoading",null,t=>{})},modalConfig:{title:""},showModal:function(t){const n={...this.modalConfig,...t};dsBridge.call("_ui.showModal",JSON.stringify(n),t=>{})},alertConfig:{itemList:["测试1","测试2","测试3","测试4","测试5"]},showActionSheet:function(t){const n={...this.alertConfig,...t};dsBridge.call("_ui.showActionSheet",JSON.stringify(n),t=>{})}};t.exports=i},4739:function(t,n,i){i("1ec6");const o=i("dcaa"),a=i("2048"),s=i("5823"),e={};e.network=o,e.nav=s,e.ui=a,t.exports=e},"4bb5":function(t,n,i){"use strict";i.r(n);var o=function(){var t=this,n=t.$createElement,i=t._self._c||n;return i("div",[t._m(0),t._m(1),i("div",{staticStyle:{margin:"16px"}},[i("van-button",{attrs:{type:"primary",round:"",block:""},on:{click:t.next}},[t._v("下一页")])],1),i("div",{staticStyle:{margin:"16px"}},[i("van-button",{attrs:{type:"primary",round:"",block:""},on:{click:t.back}},[t._v("上一页")])],1),i("div",{staticStyle:{margin:"16px"}},[i("van-button",{attrs:{type:"primary",round:"",block:""},on:{click:t.backToMicroHome}},[t._v("返回微应用首页")])],1),i("div",{staticStyle:{margin:"16px"}},[i("van-button",{attrs:{type:"primary",round:"",block:""},on:{click:t.backRoot}},[t._v("返回原生页面")])],1),i("div",{staticStyle:{margin:"16px"}},[t._v("原生跳转携带参数为: "+t._s(this.params))]),t._m(2),i("div",{staticStyle:{margin:"16px"}},[i("van-button",{attrs:{type:"primary",round:"",block:""},on:{click:t.h5back}},[t._v("上一页")])],1),i("div",{staticStyle:{margin:"16px"}},[i("van-button",{attrs:{type:"primary",round:"",block:""},on:{click:t.h5next}},[t._v("下一页")])],1),i("div",{staticStyle:{margin:"16px"}},[t._v("携带参数为: "+t._s(this.params))])])},a=[function(){var t=this,n=t.$createElement,i=t._self._c||n;return i("div",{staticStyle:{margin:"16px"}},[i("div",[t._v("current page: testD")])])},function(){var t=this,n=t.$createElement,i=t._self._c||n;return i("div",{staticStyle:{margin:"16px"}},[i("div",[t._v("原生跳转")])])},function(){var t=this,n=t.$createElement,i=t._self._c||n;return i("div",{staticStyle:{margin:"16px"}},[i("div",[t._v("h5内部跳转")])])}],s=i("69e5"),e=i.n(s),c={name:"testD",data:function(){return{params:""}},mounted:function(){this.params=this.$route.query.qid},methods:{next:function(){e.a.nav.navigatorPush({url:"/testE"})},back:function(){e.a.nav.navigatorBack()},backToMicroHome:function(){e.a.nav.navigatorBack({path:"/index"})},backRoot:function(){e.a.nav.navigatorBack({path:"0"})},h5next:function(){this.$router.push({path:"/testE",query:{qid:"113"}})},h5back:function(){this.$router.go(-1)}}},d=c,r=i("2877"),l=Object(r["a"])(d,o,a,!1,null,null,null);n["default"]=l.exports},5823:function(t,n){window.xengine=window.xengine||{};const i={navigatorPush(t){const n={...t};dsBridge.call("com.zkty.module.nav.navigatorPush",n,t=>{console.log(t)})},navigatorBack(t){const n={...t};dsBridge.call("com.zkty.module.nav.navigatorBack",n,t=>{console.log(t)})}};t.exports=i},"69e5":function(t,n,i){const o=i("4739");t.exports=o},dcaa:function(t,n){window.xengine=window.xengine||{};const i={dsBridge:window.dsBridge,requestConfig:{url:"http://127.0.0.1:8000/data0.json",method:"GET"},request:function(t){return new Promise((n,i)=>{try{const i={...this.requestConfig,...t};dsBridge.call("_network.requestNetwork",JSON.stringify(i),(function(t){n(t)}))}catch(o){i(o)}})}};t.exports=i}}]);
//# sourceMappingURL=chunk-008b0a05.cf97a0d8.js.map