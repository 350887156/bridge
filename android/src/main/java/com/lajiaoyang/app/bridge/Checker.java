package com.lajiaoyang.app.bridge;

import org.lzh.framework.updatepluginlib.base.FileChecker;
import org.lzh.framework.updatepluginlib.model.Update;

import java.io.File;

/**
 * @author LOPER7
 * @date 2018/5/25 16:35
 * @Description:
 */

public class Checker extends FileChecker {
    // 父类提供的数据。
    protected Update update;
    protected File file;

    @Override
    public boolean onCheckBeforeDownload() throws Exception {
        // 当FileCreator接口所创建的文件存在时，在检查到有更新且在启动下载任务前。触发检查
        // 返回true:检查成功。跳过下载任务并继续后续任务. 返回false:检查失败。执行下载任务并继续后续任务
        return true;
    }

    @Override
    public void onCheckBeforeInstall() throws Exception {
        // 在调用安装apk的api之前，触发检查。
        // 不抛出异常: 检查成功，调用安装api进行操作。
        // 抛出异常: 检查失败。此次更新任务失败。通知到回调方法。
    }
}