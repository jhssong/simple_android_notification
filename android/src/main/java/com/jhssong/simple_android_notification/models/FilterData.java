package com.jhssong.simple_android_notification.models;

import static com.jhssong.simple_android_notification.ErrorHandler.handleError;

import com.jhssong.simple_android_notification.ErrorHandler;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel.Result;

public class FilterData {
    private final String id;
    private final int option; // 0: all, 1: and, 2: or
    private final String packageName;
    private final String title;
    private final String text;
    private final String bigText;
    private final String infoText;
    private final String subText;
    private final String summaryText;

    public FilterData(
            String id, int option, String packageName, String title, String text, String bigText,
            String infoText, String subText, String summaryText) {
        this.id = id;
        this.option = option;
        this.packageName = packageName;
        this.title = title;
        this.text = text;
        this.bigText = bigText;
        this.infoText = infoText;
        this.subText = subText;
        this.summaryText = summaryText;
    }

    public static FilterData from(Map<String, Object> arguments) {
        String id = (String) arguments.get("id");
        int option = (int) arguments.get("option");
        String packageName = (String) arguments.get("packageName");
        String title = (String) arguments.get("title");
        String text = (String) arguments.get("text");
        String bigText = (String) arguments.get("bigText");
        String infoText = (String) arguments.get("infoText");
        String subText = (String) arguments.get("subText");
        String summaryText = (String) arguments.get("summaryText");
        return new FilterData(id, option, packageName, title, text, bigText, infoText, subText, summaryText);
    }

    public JSONObject getAsJSON(Result result) {
        JSONObject data = new JSONObject();
        try {
            data.put("id", id);
            data.put("option", option);
            data.put("packageName", packageName);
            data.put("title", title);
            data.put("text", text);
            data.put("bigText", bigText);
            data.put("infoText", infoText);
            data.put("subText", subText);
            data.put("summaryText", summaryText);
        } catch (JSONException e) {
            handleError(ErrorHandler.JSON_EXCEPTION, result, e);
        }
        return data;
    }
}
