package com.hospital.web;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class SecurityFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String path = req.getServletPath();

        // 1. ALLOW these paths to everyone (Public)
        if (path.equals("/") || path.equals("/index.jsp") || path.contains("login") ||
                path.contains("register") || path.contains("chat-ai") ||
                path.contains("get-doctors") || path.contains(".css") || path.contains(".js")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. CHECK LOGIN for everything else (Private Dashboards)
        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("user") != null);

        if (loggedIn) {
            // Check if user is trying to access a .jsp file directly
            if (path.endsWith(".jsp")) {
                // Force them to use the Servlet instead of the JSP file
                String servletPath = path.replace(".jsp", "");
                res.sendRedirect(req.getContextPath() + servletPath);
            } else {
                chain.doFilter(request, response);
            }
        } else {
            // Not logged in? Send to splash/index
            res.sendRedirect(req.getContextPath() + "/");
        }
    }
}