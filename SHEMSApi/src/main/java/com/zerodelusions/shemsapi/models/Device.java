package com.zerodelusions.shemsapi.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.OffsetDateTimeSerializer;
import com.zerodelusions.shemsapi.enums.DeviceType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "devices")
public class Device {
    // ID
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // User to which device is linked to
    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // Name
    @Column(nullable = false)
    private String name;

    // Device type, e.g., "light", "AC"
    @Column(nullable = false)
    private DeviceType type;

    // Device manufacturer, e.g., "Philips"
    private String manufacturer;

    // Model number, e.g., "Hue1234"
    private String model;

    // Power rating in watts, e.g., 60W
    @Column(nullable = false)
    private double powerRating;

    // Device status: "on", "off", "standby", etc.
    @Column(nullable = false)
    private Boolean status;

    // Date the device was installed
    @Column(nullable = false)
    private OffsetDateTime installationDate;

    // Where the device is located, e.g., "Living Room"
    @Column(nullable = false)
    private String location;
}

