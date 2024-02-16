package com.jhssong.simple_android_notification.models;

import java.util.Map;

public class NotificationData {
    public String channelId;
    public CharSequence title;
    public String content;
    public String payload;

    public NotificationData(String channelId, CharSequence title, String content, String payload) {
        this.channelId = channelId;
        this.title = title;
        this.content = content;
        this.payload = payload;
    }

    public static NotificationData from(Map<String, Object> arguments) {
        String channelId = (String) arguments.get("channelId");
        CharSequence title = (String) arguments.get("title");
        String content = (String) arguments.get("content");
        String payload = (String) arguments.get("payload");
        return new NotificationData(channelId, title, content, payload);
    }
}
