package com.zerodelusions.shemsapi.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "users")
public class User {
    // ID
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String googleId;
    private String email;
    private String name;

    public User(String name, String googleId, String email) {
        this.name = name;
        this.googleId = googleId;
        this.email = email;
    }
}
