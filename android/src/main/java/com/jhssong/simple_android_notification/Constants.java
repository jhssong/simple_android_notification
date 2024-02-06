package com.jhssong.simple_android_notification;

import com.jhssong.simple_android_notification.models.NotificationChannelInfo;

public final class Constants {
    public static final String METHOD_CHANNEL = "jhssong/simple_android_notification";
    public static final String LOG_TAG = "simple_notification";

    public static final String DEFAULT_CHANNEL_ID = "default_channel";
    public static final CharSequence DEFAULT_CHANNEL_NAME = "Default Channel";
    public static final String DEFAULT_CHANNEL_DESC = "Default Notification Channel";
    public static final int DEFAULT_CHANNEL_IMPORTANCE = 2;
    public static final NotificationChannelInfo DEFAULT_CHANNEL_INFO = new NotificationChannelInfo(
            DEFAULT_CHANNEL_ID, DEFAULT_CHANNEL_NAME, DEFAULT_CHANNEL_DESC, DEFAULT_CHANNEL_IMPORTANCE
    );
    public static final int NOTIFICATION_PERMISSIONS_REQUEST_CODE = 1001;
    public static final int NOTIFICATION_PENDING_INTENT_REQUEST_CODE = 1002;

    public static final int NOTIFICATION_NOTIFY_CODE = 4321;

    public static final String LISTENED_NOTIFICATIONS_KEY = "listened_notification_key";
    public static final String LISTENER_FILTER_KEY = "listener_filter_key";
    public static final String NOTIFICATION_PAYLOAD_KEY = "payload_key";
}
