package com.example.testjenkins.test;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface AnimalRepository extends JpaRepository<Animal, Long> {
	
	@Query("SELECT MAX(a.id) FROM Animal a")
    Integer findLatest();

    @Query("SELECT COUNT(a) FROM Animal a")
    Long findTotalAnimals();
    
	@Query("SELECT a.name FROM Animal a WHERE a.id = (SELECT MAX(a2.id) FROM Animal a2)")
	String findLatestAnimalName();
}
