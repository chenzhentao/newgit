newReposi
=========

esssselafjllkjadlf
afa;lkdjfal;dksjflakdjsf
lealklakdfjlakfjfjiekif

package com.haier.uhome.os.screencast

import android.app.Application
import android.content.Intent
import android.text.TextUtils
import com.haier.uhome.os.commonlib.BaseApplication
import com.haier.uhome.os.commonlib.amCloud.AmCastCloudManager
import com.haier.uhome.os.commonlib.amCloud.ScreencastManager
import com.haier.uhome.os.commonlib.amlocal.AMCastCallback
import com.haier.uhome.os.commonlib.amlocal.AmCastLocalManager
import com.haier.uhome.os.commonlib.bean.ControlMainActvityEvent
import com.haier.uhome.os.commonlib.bean.FinishPlayActvityEvent
import com.haier.uhome.os.commonlib.bean.ScreenPushBean
import com.haier.uhome.os.commonlib.http.Content
import com.haier.uhome.os.commonlib.http.response.DeviceResponse
import com.haier.uhome.os.commonlib.tools.LogUtils
import com.haier.uhome.os.commonlib.tools.ScreenUtils
import com.haier.uhome.os.commonlib.tools.UdpSocketManager
import com.haier.uhome.os.screencast.util.ToastUtils
import com.haier.uhome.os.screencast.view.floatingwindow.CastStateWindowManager
import com.haier.uhome.os.screencast.view.floatingwindow.ScreenWindowManager
import com.haier.uhome.os.screencast.view.videocast.ScreencastActivity
import com.haier.uhome.udp_broadcast.util.UdpSocketUtils
import org.greenrobot.eventbus.EventBus
import rxhttp.wrapper.utils.GsonUtil


class StartLocalCast private constructor() {
    private val TAG = StartLocalCast::class.java.simpleName

    companion object {
        private var instance: StartLocalCast? = null
            get() {
                if (field == null) {
                    field = StartLocalCast()
                }
                return field
            }

        fun get(): StartLocalCast {
            return instance!!
        }
    }

    fun start(
        context: Application,
        castModel: String?,
        myDeviceId: String?,
        oppositeIpAddress: String?,
        oppositeDeviceId: String?,
        targetPort: Int,
        messageId: String?
    ) {
        try {
            val deviceResponse =
                GsonUtil.fromJson<DeviceResponse>(castModel, DeviceResponse::class.java)
            if (deviceResponse.castModel == UdpSocketManager.SCREEN_CAST) {
                ScreenUtils.wakeLock()
                //播放前关闭媒体资源播放
                EventBus.getDefault().post(FinishPlayActvityEvent(Content.MEDIA_PALY_EVENT_FINISH))
                //播放前如果在局域网投屏就关闭局域网投屏,如果是云投屏就关闭云投屏
                if (AmCastLocalManager.getInstance().isCasting) {
                    AmCastLocalManager.getInstance().destroyAmMirror()
                }
                if (ScreencastManager.instance().isCloudCast) {
                    AmCastCloudManager.getInstance().stopCast()
                    AmCastCloudManager.getInstance().leaveChannel()
                }
                ScreenWindowManager.removeSmallWindow(BaseApplication.getApplication())
                CastStateWindowManager.removeSmallWindow(BaseApplication.getApplication())

                LogUtils.d(TAG, "启动傲软接收端服务")
                val intent = Intent(
                    context,
                    ScreencastActivity::class.java
                )
                intent.putExtra(Content.PLAY_URL, "111")
                intent.putExtra(Content.RESOLUTION, deviceResponse.resolution)
                if (TextUtils.isEmpty(deviceResponse.deviceModel)) {
                    intent.putExtra(Content.DEVICE_MODEL, Content.DEVICE_MODEL_NORMAL)
                } else {
                    intent.putExtra(Content.DEVICE_MODEL, deviceResponse.deviceModel)
                }
                intent.putExtra(Content.ROOM_ID, "111")
                intent.putExtra(Content.FROM_DEVICE_ID, deviceResponse.deviceId)
                intent.putExtra(Content.FROM_USER_ID, "1312")
                intent.putExtra(Content.TO_DEVICE_ID, myDeviceId)
                intent.putExtra(Content.CAST_DEVICE_NAME, deviceResponse.deviceName)
                intent.putExtra(Content.CAST_LOCATION_NAME, deviceResponse.devRoomName)
                intent.putExtra(Content.DEVICE_TYPE, deviceResponse.deviceType)
                if (TextUtils.isEmpty(deviceResponse.playerDeviceId)) {
                    intent.putExtra(Content.PLAYER_DEVICE_ID, Content.PLAYER_DEVICE_ID_NORMAL)
                } else {
                    intent.putExtra(Content.PLAYER_DEVICE_ID, deviceResponse.playerDeviceId)
                }
                if (TextUtils.isEmpty(deviceResponse.playerIp)) {
                    intent.putExtra(Content.PLAYER_IP, Content.PLAYER_IP_NORMAL)
                } else {
                    intent.putExtra(Content.PLAYER_IP, deviceResponse.playerIp)
                }
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                context.startActivity(intent)
                EventBus.getDefault().post(FinishPlayActvityEvent(Content.PALY_EVENT_STOP_CAST))
            } else if (deviceResponse.castModel == UdpSocketManager.SCREEN_RECEIVE) {
                LogUtils.d(TAG, "启动傲软发送端服务")
                ScreenUtils.wakeLock()
                if (ScreencastManager.instance() != null && !ScreencastManager.instance()!!
                        .isScreencasting()
                ) {
                    val screenPushBean = ScreenPushBean()
                    screenPushBean.deviceName = deviceResponse.deviceName
                    screenPushBean.devRoomName = deviceResponse.devRoomName
                    screenPushBean.deviceImg = deviceResponse.deviceImg
                    screenPushBean.status = Content.SCREEN_PUSH_LOADING
                    CastStateWindowManager.removeSmallWindow(BaseApplication.getApplication())
                    CastStateWindowManager.createSmallWindow(
                        BaseApplication.getApplication(),
                        screenPushBean
                    )
                }
                //投屏前关闭两个播放页面
                EventBus.getDefault().post(FinishPlayActvityEvent(Content.PALY_EVENT_FINISH))
                EventBus.getDefault().post(FinishPlayActvityEvent(Content.MEDIA_PALY_EVENT_FINISH))
                // 开启服务
                AmCastLocalManager.getInstance().initLocalSendSdk()
                AmCastLocalManager.getInstance().initMirrorCast()
                //搜索设备
                AmCastLocalManager.getInstance().searchDevice {
                    //重新唤醒屏幕
                    ScreenUtils.wakeLock()
                    // 开始投屏
                    LogUtils.d(TAG, "ip = $oppositeIpAddress")
                    AmCastLocalManager.getInstance()
                        .startMirror(oppositeIpAddress, castModel, object : AMCastCallback {
                            override fun onSuccess(ip: String?, msg: String?) {
                                ScreenWindowManager.createSmallWindow(BaseApplication.getApplication())
                                ScreencastManager.instance().updateState(
                                    myDeviceId,
                                    Content.DeviceState.DEVICE_STATE_CAST,
                                    Content.DEVICE_CAST_LOCAL
                                ) {
                                    CastStateWindowManager.removeSmallWindow(BaseApplication.getApplication())
                                    EventBus.getDefault()
                                        .post(ControlMainActvityEvent(Content.MAIN_EVENT_REFRESH_ON_DIALOG))
                                }
                            }

                            override fun onFail(ip: String?, msg: String?) {
                                CastStateWindowManager.removeSmallWindow(BaseApplication.getApplication())
                                ToastUtils.showToast(context.applicationContext, "抱歉，共享屏幕失败，请重试～")
                            }
                        })
                }
            }
            UdpSocketUtils.get(context.applicationContext).sendPullTouPingServerResultBroadcast(
                oppositeDeviceId,
                oppositeIpAddress,
                targetPort,
                messageId,
                true
            )

        } catch (exception: Exception) {
            exception.printStackTrace()
        }

    }
}
