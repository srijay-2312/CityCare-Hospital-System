package com.hospital.model;

public class Appointment {
    private int id;
    private String patientName;
    private String doctorName;
    private String appointmentDate;
    private String problem;
    private String status;
    private int doctorId;
    private String timeSlot;
    private int patientId;

    public Appointment() {}

    public Appointment(String patientName, String appointmentDate, String problem, String status, String timeSlot) {
        this.patientName = patientName;
        this.appointmentDate = appointmentDate;
        this.problem = problem;
        this.status = status;
        this.timeSlot = timeSlot;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(String appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getProblem() { return problem; }
    public void setProblem(String problem) { this.problem = problem; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    // NEW GETTER AND SETTER
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
}