package com.hospital.dao;

import com.hospital.model.Appointment;
import java.sql.*;
import java.util.*;

public class AppointmentDAO {
    private final String dbURL = System.getenv("DB_URL");
    private final String dbUsername = System.getenv("DB_USER");
    private final String dbPassword = System.getenv("DB_PASSWORD");

    protected Connection getConnection() throws SQLException {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (Exception e) {}
        return DriverManager.getConnection(dbURL, dbUsername, dbPassword);
    }

    // 1. INSERT (With Doctor ID and Time Slot)
    public void insertAppointmentWithDoctor(Appointment app, int pId, int dId) {
        String sql = "INSERT INTO appointments (patient_name, appointment_date, problem_description, status, patient_id, doctor_id, time_slot) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, app.getPatientName());
            ps.setString(2, app.getAppointmentDate());
            ps.setString(3, app.getProblem());
            ps.setString(4, app.getStatus());

            if (pId > 0) ps.setInt(5, pId);
            else ps.setNull(5, Types.INTEGER);
            ps.setInt(6, dId);
            ps.setString(7, app.getTimeSlot());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 2. INSERT (Overloaded for public servlet)
    public void insertAppointment(Appointment app, int pId) {
        insertAppointmentWithDoctor(app, pId, 1); // Defaults to doctor ID 1
    }

    // 3. FETCH (By Patient ID for Dashboard)
    public List<Appointment> getAppointmentsByPatient(int pId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, d.full_name as doc_name FROM appointments a JOIN doctors d ON a.doctor_id = d.id WHERE a.patient_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = mapResultSet(rs);
                app.setDoctorName(rs.getString("doc_name"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. FETCH (By Status for Admin Dashboard Tabs)
    public List<Appointment> getAppointmentsByStatus(String status) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, d.full_name as doc_name FROM appointments a JOIN doctors d ON a.doctor_id = d.id WHERE a.status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = mapResultSet(rs);
                app.setDoctorName(rs.getString("doc_name"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 5. FETCH SINGLE (For Editing or Printing)
    public Appointment getAppointment(int id) {
        String sql = "SELECT a.*, d.full_name as doc_name FROM appointments a JOIN doctors d ON a.doctor_id = d.id WHERE a.id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Appointment app = mapResultSet(rs);
                app.setDoctorName(rs.getString("doc_name"));
                return app;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 6. UPDATE
    public void updateAppointment(Appointment app) {
        String sql = "UPDATE appointments SET status=? WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, app.getStatus());
            ps.setInt(2, app.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 7. DELETE
    public void deleteAppointment(int id) {
        String sql = "DELETE FROM appointments WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 8. SEARCH
    public List<Appointment> searchAppointments(String keyword) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, d.full_name as doc_name FROM appointments a JOIN doctors d ON a.doctor_id = d.id WHERE a.patient_name LIKE ? ORDER BY a.appointment_date DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = mapResultSet(rs);
                app.setDoctorName(rs.getString("doc_name"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 9. FETCH ALL (For Public List/Reports)
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, d.full_name as doc_name FROM appointments a JOIN doctors d ON a.doctor_id = d.id ORDER BY a.appointment_date DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = mapResultSet(rs);
                app.setDoctorName(rs.getString("doc_name"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 10. SLOT VALIDATION
    public boolean isSlotAvailable(int dId, String date, String time) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE doctor_id=? AND appointment_date=? AND time_slot=? AND status!='Cancelled'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dId);
            ps.setString(2, date);
            ps.setString(3, time);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) == 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 11. STATS (RE-ADDED: For Chart.js)
    public Map<String, Integer> getAppointmentStats() {
        Map<String, Integer> stats = new HashMap<>();
        // Ensure each key is only added once
        stats.put("Pending", 0);
        stats.put("Scheduled", 0);
        stats.put("Completed", 0);

        String sql = "SELECT status, COUNT(*) as count FROM appointments GROUP BY status";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString("status"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    // Internal Mapping Helper
    private Appointment mapResultSet(ResultSet rs) throws SQLException {
        Appointment app = new Appointment();
        app.setId(rs.getInt("id"));
        app.setPatientName(rs.getString("patient_name"));
        app.setAppointmentDate(rs.getString("appointment_date"));
        app.setTimeSlot(rs.getString("time_slot"));
        app.setProblem(rs.getString("problem_description"));
        app.setStatus(rs.getString("status"));

        // THE IMPORTANT NEW LINE:
        app.setPatientId(rs.getInt("patient_id"));

        return app;
    }
}