package com.hospital.web;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

@WebServlet("/chat-ai")
public class AIChatServlet extends HttpServlet {

    // Professional way: No secret key visible here
    private static final String API_KEY = System.getenv("GROQ_API_KEY");    private static final String API_URL = "https://api.groq.com/openai/v1/chat/completions";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 1. SET HEADERS FIRST
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String body = request.getReader().lines().collect(Collectors.joining());
            JsonObject jsonInput = JsonParser.parseString(body).getAsJsonObject();
            String symptoms = jsonInput.get("message").getAsString();

            // Prepare Groq Request
            JsonObject payload = new JsonObject();
            payload.addProperty("model", "llama-3.1-8b-instant");
            JsonArray messages = new JsonArray();
            JsonObject sys = new JsonObject();
            sys.addProperty("role", "system");
            sys.addProperty("content", "You are a medical assistant. Recommend one hospital department in one short sentence.");
            JsonObject usr = new JsonObject();
            usr.addProperty("role", "user");
            usr.addProperty("content", symptoms);
            messages.add(sys); messages.add(usr);
            payload.add("messages", messages);

            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + API_KEY.trim());
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(payload.toString().getBytes(StandardCharsets.UTF_8));
            }

            if (conn.getResponseCode() == 200) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                String resStr = br.lines().collect(Collectors.joining());
                JsonObject resObj = JsonParser.parseString(resStr).getAsJsonObject();
                String aiAns = resObj.getAsJsonArray("choices").get(0).getAsJsonObject()
                        .getAsJsonObject("message").get("content").getAsString();

                // 2. CREATE A CLEAN JSON OBJECT
                JsonObject finalJson = new JsonObject();
                finalJson.addProperty("answer", aiAns.trim());

                // 3. PRINT TO INTELLIJ CONSOLE (To prove it works)
                System.out.println("JSON BEING SENT TO BROWSER: " + finalJson.toString());

                // 4. SEND TO BROWSER
                out.print(finalJson.toString());
            } else {
                out.print("{\"answer\": \"Please visit General Medicine.\"}");
            }
        } catch (Exception e) {
            out.print("{\"answer\": \"System busy. Please try again.\"}");
        }
        out.flush();
    }
}