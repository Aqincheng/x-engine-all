package com.zkty.engine.module.device;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Build;
import android.os.Bundle;
import android.view.View;

import com.zkty.modules.engine.utils.XEngineWebActivityManager;

public class MainActivity extends AppCompatActivity {


    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

    }

    public void device(View view) {
        XEngineWebActivityManager.sharedInstance().startXEngineActivity(this,"http://192.168.0.167:8080/");
    }
}