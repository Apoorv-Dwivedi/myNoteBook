package com.notesapp.repositories;

import com.notesapp.entity.Note;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NoteRepository extends JpaRepository<Note, Long> {

    List<Note> findByNotebookId(Long notebookId);

    List<Note> findByOwnerId(Long ownerId);

    // Ownership check — only return the note if it belongs to this user
    Optional<Note> findByIdAndOwnerId(Long id, Long ownerId);
}
