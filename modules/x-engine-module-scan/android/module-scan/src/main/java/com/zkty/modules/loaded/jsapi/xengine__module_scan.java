
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

  
  class ScanOpenDto {
    public String __event__;
  }
  
  interface xengine__module_scan_i {
    public void _openScanView(ScanOpenDto dto, final CompletionHandler<Nullable> handler);
  }
  
  
  public abstract class xengine__module_scan extends xengine__module_BaseModule implements xengine__module_scan_i {
    @Override
    public String moduleId() {
      return "com.zkty.module.scan";
    }
  
    @JavascriptInterface
    final public void openScanView(JSONObject obj, final CompletionHandler<Object> handler) {
      ScanOpenDto data= convert(obj,ScanOpenDto.class);
      _openScanView(data, new CompletionHandler<Nullable>() {
        @Override
        public void complete(Nullable retValue) { handler.complete(null); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(Nullable value) { handler.setProgressData(null); }
      });

    }
  }
  

  