
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

  
  class DcloudDTO {
    public String appId;
  }
  
  class UniMPDTO {
    public String appId;

    public Map<String,String> arguments;

    public String redirectPath;

    public boolean enableBackground;

    @Optional
		public boolean showAnimated;

    @Optional
		public boolean hideAnimated;
  }
  
  interface xengine__module_dcloud_i {
    public void _openUniMP(DcloudDTO dto, final CompletionHandler<Nullable> handler);
public void _preloadUniMP(DcloudDTO dto, final CompletionHandler<Nullable> handler);
public void _openUniMPWithArg(UniMPDTO dto, final CompletionHandler<Nullable> handler);
  }
  
  
  public abstract class xengine__module_dcloud extends xengine__module_BaseModule implements xengine__module_dcloud_i {
    @Override
    public String moduleId() {
      return "com.zkty.module.dcloud";
    }
  
    @JavascriptInterface
    final public void openUniMP(JSONObject obj, final CompletionHandler<Object> handler) {
      DcloudDTO data= convert(obj,DcloudDTO.class);
      _openUniMP(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void preloadUniMP(JSONObject obj, final CompletionHandler<Object> handler) {
      DcloudDTO data= convert(obj,DcloudDTO.class);
      _preloadUniMP(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }

    @JavascriptInterface
    final public void openUniMPWithArg(JSONObject obj, final CompletionHandler<Object> handler) {
      UniMPDTO data= convert(obj,UniMPDTO.class);
      _openUniMPWithArg(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }
  }
  

  