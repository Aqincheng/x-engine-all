
// DO NOT MODIFY!.
// generated by x-cli, it will be overwrite eventually!

  package com.zkty.modules.loaded.jsapi;

  import java.util.List;
  import java.util.Map;
  import java.util.Set;
  import android.webkit.JavascriptInterface;
  import com.alibaba.fastjson.JSONObject;
  import com.zkty.modules.dsbridge.CompletionHandler;
  import com.zkty.modules.engine.annotation.Optional;
  import com.zkty.modules.engine.core.xengine__module_BaseModule;
  import androidx.annotation.Nullable;

  
  class NavTitleDTO {
    public String title;

    public String titleColor;

    public Integer titleSize;
  }
  
  class NavPopItem {
    @Optional
		public String icon;

    @Optional
		public String iconSize;

    public String title;

    @Optional
		public String __event__;
  }
  
  class NavBtnDTO {
    public String title;

    public String titleColor;

    public Integer titleSize;

    @Optional
		public String icon;

    public List<Double> iconSize;

    @Optional
		public List<Map<String,String>> popList;

    @Optional
		public String showMenuImg;

    @Optional
		public String popWidth;

    @Optional
		public String __event__;
  }
  
  class NavMoreBtnDTO {
    public List<NavBtnDTO> btns;
  }
  
  class NavNavigatorDTO {
    @Optional
		public String url;

    @Optional
		public String params;
  }
  
  class NavOpenAppDTO {
    public String type;

    public String uri;

    public String path;
  }
  
  class NavSearchBarDTO {
    public Integer cornerRadius;

    public String backgroundColor;

    public String iconSearch;

    public List<Double> iconSearchSize;

    public String iconClear;

    public List<Double> iconClearSize;

    public String textColor;

    public Integer fontSize;

    public String placeHolder;

    public Integer placeHolderFontSize;

    public boolean isInput;

    public boolean becomeFirstResponder;

    @Optional
		public String __event__;
  }
  
  interface xengine__module_nav_i {
    public void _setNavTitle(NavTitleDTO dto, final CompletionHandler<Nullable> handler);
public void _setNavLeftBtn(NavBtnDTO dto, final CompletionHandler<Nullable> handler);
public void _setNavRightBtn(NavBtnDTO dto, final CompletionHandler<Nullable> handler);
public void _setNavRightMenuBtn(NavBtnDTO dto, final CompletionHandler<Nullable> handler);
public void _setNavRightMoreBtn(NavMoreBtnDTO dto, final CompletionHandler<Nullable> handler);
public void _navigatorPush(NavNavigatorDTO dto, final CompletionHandler<Nullable> handler);
public void _navigatorBack(NavNavigatorDTO dto, final CompletionHandler<Nullable> handler);
public void _navigatorRouter(NavOpenAppDTO dto, final CompletionHandler<Nullable> handler);
public void _setNavSearchBar(NavSearchBarDTO dto, final CompletionHandler<Nullable> handler);
  }
  
  
  public abstract class xengine__module_nav extends xengine__module_BaseModule implements xengine__module_nav_i {
    @Override
    public String moduleId() {
      return "com.zkty.module.nav";
    }
  
    @JavascriptInterface
    final public void setNavTitle(JSONObject obj, final CompletionHandler<Object> handler) {
      NavTitleDTO data= convert(obj,NavTitleDTO.class);
      _setNavTitle(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void setNavLeftBtn(JSONObject obj, final CompletionHandler<Object> handler) {
      NavBtnDTO data= convert(obj,NavBtnDTO.class);
      _setNavLeftBtn(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void setNavRightBtn(JSONObject obj, final CompletionHandler<Object> handler) {
      NavBtnDTO data= convert(obj,NavBtnDTO.class);
      _setNavRightBtn(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void setNavRightMenuBtn(JSONObject obj, final CompletionHandler<Object> handler) {
      NavBtnDTO data= convert(obj,NavBtnDTO.class);
      _setNavRightMenuBtn(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void setNavRightMoreBtn(JSONObject obj, final CompletionHandler<Object> handler) {
      NavMoreBtnDTO data= convert(obj,NavMoreBtnDTO.class);
      _setNavRightMoreBtn(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void navigatorPush(JSONObject obj, final CompletionHandler<Object> handler) {
      NavNavigatorDTO data= convert(obj,NavNavigatorDTO.class);
      _navigatorPush(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void navigatorBack(JSONObject obj, final CompletionHandler<Object> handler) {
      NavNavigatorDTO data= convert(obj,NavNavigatorDTO.class);
      _navigatorBack(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void navigatorRouter(JSONObject obj, final CompletionHandler<Object> handler) {
      NavOpenAppDTO data= convert(obj,NavOpenAppDTO.class);
      _navigatorRouter(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void setNavSearchBar(JSONObject obj, final CompletionHandler<Object> handler) {
      NavSearchBarDTO data= convert(obj,NavSearchBarDTO.class);
      _setNavSearchBar(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }
  }
  

  