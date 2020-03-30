package com.lajiaoyang.app.bridge;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.util.Log;
import org.json.JSONObject;
import org.lzh.framework.updatepluginlib.UpdateBuilder;
import org.lzh.framework.updatepluginlib.UpdateConfig;
import org.lzh.framework.updatepluginlib.base.CheckCallback;
import org.lzh.framework.updatepluginlib.base.UpdateParser;
import org.lzh.framework.updatepluginlib.base.UpdateStrategy;
import org.lzh.framework.updatepluginlib.model.CheckEntity;
import org.lzh.framework.updatepluginlib.model.Update;
import com.lajiaoyang.app.bridge.AppInfo;
import java.util.HashMap;
import java.util.Map;
import com.lajiaoyang.app.bridge.GsonUtils;

public class UpdateManager {
	private static final String TAG="UpdateManager";
    private static UpdateManager updateManager;
    private boolean isLatestVersion = true;

    public synchronized static UpdateManager getInstance() {
        if (updateManager == null)
            return updateManager = new UpdateManager();
        return updateManager;
    }
    public UpdateManager setup(String url,Map parameter) {
        UpdateConfig.getConfig()
                .setCheckEntity(new CheckEntity().setUrl(url).setParams(parameter))// 配置检查更新的API接口
                .setFileChecker(new Checker())
                .setUpdateStrategy(new UpdateStrategy() {
                    @Override
                    public boolean isShowUpdateDialog(Update update) {
                        return true;
                    }

                    @Override
                    public boolean isShowDownloadDialog() {
                        return true;
                    }

                    @Override
                    public boolean isAutoInstall() {
                        return true;
                    }
                })
                .setUpdateParser(new UpdateParser() {
                    @Override
                    public Update parse(String response) throws Exception {
                        JSONObject jsonObject = new JSONObject(response);
                        AppInfo updateBean = GsonUtils.fromJson(jsonObject.getString("data"), AppInfo.class);
                        Update update = new Update();
                        update.setVersionName(updateBean.version);
                        update.setVersionCode(updateBean.versionCode);
                        update.setUpdateContent(updateBean.description);
                        update.setForced(updateBean.type == 1);
                        update.setUpdateUrl(updateBean.apkUrl);
                        return update;
                    }
                });
        return this;
    }
    /**
     * 启动更新任务
     */
    public void startCheck() {
        UpdateBuilder.create().setCheckCallback(new CheckCallback() {
            @Override
            public void onCheckStart() {

            }

            @Override
            public void hasUpdate(Update update) {
                isLatestVersion = false;
            }

            @Override
            public void noUpdate() {
                isLatestVersion = true;
            }

            @Override
            public void onCheckError(Throwable t) {
                Log.e("loper7", t.getMessage());
            }

            @Override
            public void onUserCancel() {

            }

            @Override
            public void onCheckIgnore(Update update) {

            }
        }).check();
    }

    /**
     * 启动更新任务
     */
    public void startCheck(CheckCallback checkCallback) {
        UpdateBuilder.create().setCheckCallback(checkCallback).check();
    }

    /**
     * 当前是否为最新版本
     *
     * @return
     */
    public boolean isLatestVersion() {
        return isLatestVersion;
    }

    /**
     * 获取版本信息
     *
     * @return
     */
    public PackageInfo getPackageInfo(Context context) {
        PackageManager packageManager = context.getPackageManager();
        PackageInfo packInfo = null;
        try {
            packInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return packInfo;
    }


}
