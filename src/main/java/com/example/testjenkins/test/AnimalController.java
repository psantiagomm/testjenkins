package com.example.testjenkins.test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/animals")
public class AnimalController {
	@Autowired
    private AnimalRepository animalRepository;

    @PostMapping
    public ResponseEntity<Animal> createAnimal(@RequestBody Animal animal) {
        Animal savedAnimal = animalRepository.save(animal);
        return ResponseEntity.ok(savedAnimal);
    }
    
    @GetMapping("/statistics")
    public ResponseEntity<AnimalStatistics> getUserStatistics() {

        AnimalStatistics statistics = new AnimalStatistics();
        
        statistics.setTotalAnimals(animalRepository.findTotalAnimals());
        statistics.setMaxId(animalRepository.findLatest());
        statistics.setMaxIdName(animalRepository.findLatestAnimalName());

        return ResponseEntity.ok(statistics);
    }
}
