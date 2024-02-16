package com.jhssong.simple_android_notification;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel.Result;

public enum ErrorHandler {
    JSON_EXCEPTION("1002", "Failed to add item to JsonArray"),
    NOTIFY_FAILED("3001", "Failed to send notifications");

    private final String code;
    private final String reason;

    ErrorHandler(String code, String reason) {
        this.code = code;
        this.reason = reason;
    }

    public static void handleError(ErrorHandler code, Result result, Exception e) {
        if (e != null)
            Log.e(Constants.LOG_TAG, e.getMessage());
        result.error(code.getCode(), code.getMsg(), null);
    }

    public String getCode() {
        return code;
    }

    public String getMsg() {
        return reason;
    }
}
