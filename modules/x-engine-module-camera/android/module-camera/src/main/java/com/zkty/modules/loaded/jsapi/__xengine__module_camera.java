package com.zkty.modules.loaded.jsapi;

import android.Manifest;
import android.app.Activity;
import android.app.Dialog;
import android.content.ClipData;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.hardware.Camera;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;

import com.alibaba.fastjson.JSONObject;
import com.zkty.modules.dsbridge.CompletionHandler;
import com.zkty.modules.dsbridge.OnReturnValue;
import com.zkty.modules.engine.activity.XEngineWebActivity;
import com.zkty.modules.engine.core.IApplicationListener;
import com.zkty.modules.engine.exception.XEngineException;
import com.zkty.modules.engine.utils.FileUtils;
import com.zkty.modules.engine.utils.XEngineWebActivityManager;
import com.zkty.modules.loaded.imp.ImagePicker;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;

import module.camera.R;


public class __xengine__module_camera extends xengine__module_camera implements IApplicationListener {
    private static final String TAG = "XEngine__module_camera";


    private XEngineWebActivity.LifecycleListener lifeCycleListener;
    private int REQUEST_OBTAIN_PIC = 1;

    private CameraDTO cameraDTO;
    private static int REQUEST_CAMERA = 10;     //启动相机
    private static int REQUEST_ALBUM = 11;      //启动相册
    private static int REQUEST_CROP = 12;       //启动裁剪

    private static int PERMISSION_REQUEST_CAMERA = 20;


    private File out;


    @Override
    public void onAppCreate(Context context) {
        Log.d(TAG, "onAppCreate()");
    }

    @Override
    public void onAppLowMemory() {
        Log.d(TAG, "onAppLowMemory()");
    }

    @Override
    public String moduleId() {
        return "com.zkty.module.camera";
    }

    @Override
    public void onAllModulesInited() {
        super.onAllModulesInited();
    }


    @Override
    public void _openImagePicker(final CameraDTO dto, final CompletionHandler<RetDTO> handler) {
        Log.d(TAG, "receive object:" + JSONObject.toJSONString(dto));
        cameraDTO = dto;
//        //test
//        cameraDTO.allowsEditing = false;
//        cameraDTO.savePhotosAlbum = false;
//        cameraDTO.cameraDevice = "front";

        out = null;
        final XEngineWebActivity act = (XEngineWebActivity) XEngineWebActivityManager.sharedInstance().getCurrent();
        if (lifeCycleListener == null) {
            lifeCycleListener = new XEngineWebActivity.LifecycleListener() {
                @Override
                public void onCreate() {

                }

                @Override
                public void onStart() {

                }

                @Override
                public void onRestart() {

                }

                @Override
                public void onResume() {

                }

                @Override
                public void onPause() {

                }

                @Override
                public void onStop() {

                }

                @Override
                public void onDestroy() {

                }

                @Override
                public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
                    Log.d(TAG, "onActivityResult---" + "requestCode:" + requestCode + "---resultCode:" + resultCode);

                    if (resultCode == Activity.RESULT_OK) {
                        if (requestCode == REQUEST_OBTAIN_PIC) {
                            ArrayList<String> items = data.getStringArrayListExtra(ImagePicker.EXTRA_SELECT_IMAGES);
                            StringBuffer stringBuffer = new StringBuffer();
                            stringBuffer.append("当前选中图片路径：\n");
                            for (int i = 0; i < items.size(); i++) {
                                stringBuffer.append(items.get(i) + "\n");
                            }
                            Log.d(TAG, "selected:" + stringBuffer.toString());

                            if (mXEngineWebView != null && items != null) {
                                String path = items.get(0);                 //原始文件位置
                                File file = new File(path);
                                Log.d(TAG, file.getParent() + "---" + file.getName());

                                mXEngineWebView.callHandler(dto.__event__, new Object[]{path}, new OnReturnValue<Object>() {
                                    @Override
                                    public void onValue(Object retValue) {

                                    }
                                });
                            } else {
                                throw new XEngineException("XEngineWebView is null!");
                            }
                        } else if (requestCode == REQUEST_CAMERA) {                 //相机返回
                            Log.d(TAG, "camera:---path:" + out.getPath());

                            if (cameraDTO.savePhotosAlbum) {                //保存到相册功能需要适配
                                // 其次把文件插入到系统图库
                                try {
                                    MediaStore.Images.Media.insertImage(act.getContentResolver(), out.getAbsolutePath(), out.getName(), null);
                                } catch (FileNotFoundException e) {
                                    e.printStackTrace();
                                }

                                // 最后通知图库更新
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) { // 判断SDK版本是不是4.4或者高于4.4
                                    String[] paths = new String[]{out.getPath()};
                                    MediaScannerConnection.scanFile(act, paths, null, null);
                                } else {
                                    Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
                                    intent.setData(Uri.fromFile(out));
                                    act.sendBroadcast(intent);
                                }
                            }

                            if (out.exists()) {
                                if (cameraDTO.allowsEditing) {
                                    crop(act, FileProvider.getUriForFile(act, act.getPackageName() + ".provider", out), out.getParentFile(), out.getName());
                                } else {
                                    if (mXEngineWebView != null) {
                                        mXEngineWebView.callHandler(dto.__event__, new Object[]{out.getPath()}, new OnReturnValue<Object>() {
                                            @Override
                                            public void onValue(Object retValue) {

                                            }
                                        });
                                    } else {
                                        throw new XEngineException("XEngineWebView is null!");
                                    }
                                }
                            }
                        } else if (requestCode == REQUEST_ALBUM) {                  //相册返回
                            Uri uri = data.getData();
                            Log.d(TAG, "album:" + uri.toString());
                            try {
                                long timestamp = System.currentTimeMillis();
                                out = new File(act.getCacheDir(), "temp_" + timestamp + ".jpg");

                                String file = FileUtils.saveFile(act.getContentResolver().openInputStream(uri), out.getParentFile(), out.getName());          //读取相册原始文件并保存到缓存目录

                                if (!TextUtils.isEmpty(file)) {
                                    Log.d(TAG, "out:" + out.getPath());

                                    if (cameraDTO.allowsEditing) {              //编辑
                                        crop(act, uri, out.getParentFile(), out.getName());
                                    } else {                                    //直接返回
                                        if (mXEngineWebView != null && out.exists()) {
                                            mXEngineWebView.callHandler(dto.__event__, new Object[]{out.getPath()}, new OnReturnValue<Object>() {
                                                @Override
                                                public void onValue(Object retValue) {

                                                }
                                            });
                                        } else {
                                            throw new XEngineException("XEngineWebView is null!");
                                        }
                                    }
                                }
                            } catch (Exception e) {

                            }
                        } else if (requestCode == REQUEST_CROP) {                   //裁剪返回
                            Log.d(TAG, "crop:");

                            if (mXEngineWebView != null && out.exists()) {
                                String path = out.getPath();
                                Log.d(TAG, "path:" + path);
                                mXEngineWebView.callHandler(dto.__event__, new Object[]{path}, new OnReturnValue<Object>() {
                                    @Override
                                    public void onValue(Object retValue) {

                                    }
                                });
                            } else {
                                throw new XEngineException("XEngineWebView is null!");
                            }
                        }
                    }
                }

                @Override
                public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
                    Log.d(TAG, "onRequestPermissionsResult" + requestCode);
                    if (requestCode == PERMISSION_REQUEST_CAMERA) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            if (act.checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
                                showDialog(act);
                            }
                        }
                    }
                }
            };
        }
        act.addLifeCycleListener(lifeCycleListener);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && act.checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            act.requestPermissions(new String[]{Manifest.permission.CAMERA}, PERMISSION_REQUEST_CAMERA);
        } else {
            showDialog(act);
        }

//        ImagePicker.getInstance()
//                .setTitle("选择图片")//设置标题
//                .showCamera(true)//设置是否显示拍照按钮
//                .showImage(true)//设置是否展示图片
//                .showVideo(false)//设置是否展示视频
//                .filterGif(true)//设置是否过滤gif图片
//                .setMaxCount(1)//设置最大选择图片数目(默认为1，单选)
//                .setSingleType(true)//设置图片视频不能同时选择
//                .setImageLoader(new GlideLoader())//设置自定义图片加载器
//                .start(act, REQUEST_OBTAIN_PIC);//REQEST_SELECT_IMAGES_CODE为Intent调用的requestCode
    }

    /**
     * @param act
     */
    private void showDialog(final Activity act) {
        final Dialog dialog = new Dialog(act);
        View content = LayoutInflater.from(act).inflate(R.layout.dialog_select_photo_layout, null);
        content.findViewById(R.id.camera).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {                                                   //相机
                dialog.dismiss();
                startCamera(act);
            }
        });

        content.findViewById(R.id.album).setOnClickListener(new View.OnClickListener() {            //相册
            @Override
            public void onClick(View v) {
                dialog.dismiss();

                startAlbum(act);
            }
        });
        dialog.getWindow().setContentView(content, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        dialog.show();
    }

    /**
     * 启动相机
     *
     * @param activity
     */
    private void startCamera(Activity activity) {
        if (Camera.getNumberOfCameras() <= 0) {
            return;
        }
        out = new File(activity.getCacheDir(), "temp_" + System.currentTimeMillis() + ".jpg");

        Uri uri;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            uri = FileProvider.getUriForFile(activity, activity.getPackageName() + ".provider", out);
        } else {
            uri = Uri.fromFile(out);
        }

        boolean hasFront = false, hasBack = false;
        Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
        for (int i = 0; i < Camera.getNumberOfCameras(); i++) {
            Camera.getCameraInfo(i, cameraInfo);
            if (cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
                hasFront = true;
            } else if (cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_BACK) {
                hasBack = true;
            }
        }

        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);// 启动系统相机
        if (!TextUtils.isEmpty(cameraDTO.cameraDevice) && cameraDTO.cameraDevice.equals("front")) {
            if (hasFront) {
                intent.putExtra("android.intent.extras.CAMERA_FACING", Camera.CameraInfo.CAMERA_FACING_FRONT); // 调用前置摄像头
            } else {
                intent.putExtra("android.intent.extras.CAMERA_FACING", Camera.CameraInfo.CAMERA_FACING_BACK); // 调用后置摄像头
            }
        } else {
            if (hasBack) {
                intent.putExtra("android.intent.extras.CAMERA_FACING", Camera.CameraInfo.CAMERA_FACING_BACK); // 调用后置摄像头
            } else {
                intent.putExtra("android.intent.extras.CAMERA_FACING", Camera.CameraInfo.CAMERA_FACING_FRONT); // 调用前置摄像头
            }
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        activity.startActivityForResult(intent, REQUEST_CAMERA);
    }


    /**
     * 启动相册
     *
     * @param activity
     */
    private void startAlbum(Activity activity) {
        Intent intent = new Intent(Intent.ACTION_PICK);
        intent.setType("image/*");
        activity.startActivityForResult(intent, REQUEST_ALBUM);
    }

    /**
     * 打开系统图片剪切
     *
     * @param activity
     * @param uri      需要裁剪的图片地址
     * @param dir      裁剪后输出的目录
     * @param fileName 裁剪后输出的文件名
     */
    private void crop(Activity activity, Uri uri, File dir, String fileName) {
        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setDataAndType(uri, "image/*");
        intent.putExtra("crop", "true");

        Uri photoUri;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
            photoUri = FileProvider.getUriForFile(activity, activity.getPackageName() + ".provider", new File(dir, fileName));
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.setClipData(ClipData.newRawUri(MediaStore.EXTRA_OUTPUT, photoUri));
        } else {
            photoUri = Uri.fromFile(new File(dir, fileName));
        }

        intent.putExtra(MediaStore.EXTRA_OUTPUT, photoUri); //指定输出的文件路径及文件名
        intent.putExtra("aspectX", 1);
        intent.putExtra("aspectY", 1);
        intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG);
        intent.putExtra("outputX", 720);
        intent.putExtra("outputY", 720);
        intent.putExtra("scale", true);
        intent.putExtra("scaleUpIfNeeded", true);
        intent.putExtra("return-data", false);
        activity.startActivityForResult(intent, REQUEST_CROP);
    }
}
