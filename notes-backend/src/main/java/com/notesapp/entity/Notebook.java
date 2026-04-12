package com.notesapp.entity;


import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "notebooks")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Notebook {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(min = 1, max = 100)
    @Column(nullable = false)
    private String name;

    @Size(max = 255)
    private String description;

    @ManyToOne(fetch = FetchType.LAZY , optional = false)
    @JoinColumn(
            name = "owner_id",
            nullable = false
    )
    private User owner;

    @OneToMany(mappedBy = "notebook", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Note> notes = new ArrayList<>();

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
