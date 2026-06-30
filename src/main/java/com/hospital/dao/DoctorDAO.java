package com.hospital.dao;

import com.hospital.model.Department;
import com.hospital.model.Doctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {
    private final String dbURL = System.getenv("DB_URL");
    private final String dbUsername = System.getenv("DB_USER");
    private final String dbPassword = System.getenv("DB_PASSWORD");

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    // Get all departments for the dropdown
    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM departments";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("id"));
                dept.setName(rs.getString("name"));
                list.add(dept);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Get all doctors for a specific department
    public List<Doctor> getDoctorsByDepartment(int deptId) {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT * FROM doctors WHERE dept_id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, deptId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Doctor doc = new Doctor();
                doc.setId(rs.getInt("id"));
                doc.setFullName(rs.getString("full_name"));
                doc.setSpecialization(rs.getString("specialization"));
                doc.setDeptId(rs.getInt("dept_id"));
                list.add(doc);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    // 1. Add a new Department
    public void addDepartment(String name) {
        String sql = "INSERT INTO departments (name) VALUES (?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 2. Add a new Doctor
    public void addDoctor(String name, String spec, int deptId) {
        String sql = "INSERT INTO doctors (full_name, specialization, dept_id) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.setString(2, spec);
            pstmt.setInt(3, deptId);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 3. Delete a Doctor
    public void deleteDoctor(int id) {
        String sql = "DELETE FROM doctors WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 4. Get all Doctors for the management list
    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT * FROM doctors";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Doctor doc = new Doctor();
                doc.setId(rs.getInt("id"));
                doc.setFullName(rs.getString("full_name"));
                doc.setSpecialization(rs.getString("specialization"));
                doc.setDeptId(rs.getInt("dept_id"));
                list.add(doc);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Doctor getDoctorById(int id) {
        Doctor doc = null;
        String sql = "SELECT * FROM doctors WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                doc = new Doctor();
                doc.setId(rs.getInt("id"));
                doc.setFullName(rs.getString("full_name"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return doc;
    }
}