
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

  
  class StorageSetDTO {
    public String key;

    public String value;

    public boolean isPublic;
  }
  
  class StorageGetDTO {
    public String key;

    public boolean isPublic;
  }
  
  class StorageRemoveDTO {
    public String key;

    public boolean isPublic;
  }
  
  class StorageRemoveAllDTO {
    public boolean isPublic;
  }
  
  class StorageStatusDTO {
    public String result;
  }
  
  interface xengine__module_localstorage_i {
    public void _set(StorageSetDTO dto, final CompletionHandler<StorageStatusDTO> handler);
public void _get(StorageGetDTO dto, final CompletionHandler<StorageStatusDTO> handler);
public void _remove(StorageRemoveDTO dto, final CompletionHandler<StorageStatusDTO> handler);
public void _removeAll(StorageRemoveAllDTO dto, final CompletionHandler<StorageStatusDTO> handler);
  }
  
  
  public abstract class xengine__module_localstorage extends xengine__module_BaseModule implements xengine__module_localstorage_i {
    @Override
    public String moduleId() {
      return "com.zkty.module.localstorage";
    }
  
    @JavascriptInterface
    final public void set(JSONObject obj, final CompletionHandler<Object> handler) {
      StorageSetDTO data= convert(obj,StorageSetDTO.class);
      _set(data, new CompletionHandler<StorageStatusDTO>() {
        @Override
        public void complete(StorageStatusDTO retValue) { handler.complete(retValue); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(StorageStatusDTO value) { handler.setProgressData(value); }
      });

    }

    @JavascriptInterface
    final public void get(JSONObject obj, final CompletionHandler<Object> handler) {
      StorageGetDTO data= convert(obj,StorageGetDTO.class);
      _get(data, new CompletionHandler<StorageStatusDTO>() {
        @Override
        public void complete(StorageStatusDTO retValue) { handler.complete(retValue); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(StorageStatusDTO value) { handler.setProgressData(value); }
      });

    }

    @JavascriptInterface
    final public void remove(JSONObject obj, final CompletionHandler<Object> handler) {
      StorageRemoveDTO data= convert(obj,StorageRemoveDTO.class);
      _remove(data, new CompletionHandler<StorageStatusDTO>() {
        @Override
        public void complete(StorageStatusDTO retValue) { handler.complete(retValue); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(StorageStatusDTO value) { handler.setProgressData(value); }
      });

    }

    @JavascriptInterface
    final public void removeAll(JSONObject obj, final CompletionHandler<Object> handler) {
      StorageRemoveAllDTO data= convert(obj,StorageRemoveAllDTO.class);
      _removeAll(data, new CompletionHandler<StorageStatusDTO>() {
        @Override
        public void complete(StorageStatusDTO retValue) { handler.complete(retValue); }
        @Override
        public void complete() { handler.complete(); }
        @Override
        public void setProgressData(StorageStatusDTO value) { handler.setProgressData(value); }
      });

    }
  }
  

  