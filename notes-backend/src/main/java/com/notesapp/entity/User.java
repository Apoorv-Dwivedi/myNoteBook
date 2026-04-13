package com.notesapp.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Email
    @Column(unique = true)
    private String email;

    @Column(name = "password_hash",nullable = false)
    private String passwordHash;

    @Column(name = "phone_number",unique = true)
    private String phoneNumber;

    @Enumerated(value = EnumType.STRING)
    @Column(nullable = false, name = "status")
    @Builder.Default
    private AccountStatus status= AccountStatus.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, name ="role")
    @Builder.Default
    private Role role= Role.USER;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at" )
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "owner" , cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Notebook> notebooks = new ArrayList<>();
}

