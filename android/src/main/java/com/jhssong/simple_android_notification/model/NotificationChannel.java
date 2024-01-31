package com.jhssong.simple_android_notification.model;

public class NotificationChannel {
    private String id;
    private String name;
    private String desc;
    private int importance;

    public NotificationChannel(String id, String name, String desc, int importance) {
        this.id = id;
        this.name = name;
        this.desc = desc;
        this.importance = importance;
    }
}
