package com.hospital.dao;

import com.hospital.model.User;
import com.hospital.model.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    // These names match the Environment Variables for Render deployment
    private final String dbURL = System.getenv("DB_URL");
    private final String dbUsername = System.getenv("DB_USER");
    private final String dbPassword = System.getenv("DB_PASSWORD");

    protected Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(dbURL, dbUsername, dbPassword);
    }

    // 1. LOGIN LOGIC
    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, PasswordUtil.hashPassword(password));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("full_name"),
                        rs.getString("role")
                );
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // 2. REGISTRATION LOGIC
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, email, password, full_name, role) VALUES (?, ?, ?, ?, 'patient')";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFullName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // 3. GET USER BY ID (For Email logic)
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                return u;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // 4. GET ALL ADMINS (For Staff List)
    public List<User> getAllAdmins() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'admin'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new User(rs.getInt("id"), rs.getString("username"), rs.getString("email"), rs.getString("full_name"), rs.getString("role")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 5. RESET PASSWORD (The method that was missing)
    public boolean resetPassword(String username, String fullName, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE username = ? AND full_name = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hashPassword(newPassword));
            ps.setString(2, username);
            ps.setString(3, fullName);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}