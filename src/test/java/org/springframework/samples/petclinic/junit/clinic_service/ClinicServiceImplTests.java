package org.springframework.samples.petclinic.junit.clinic_service;


import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.samples.petclinic.model.*;
import org.springframework.samples.petclinic.repository.*;
import org.springframework.samples.petclinic.service.ClinicServiceImpl;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ClinicServiceImplTests {

    @Mock
    private PetRepository petRepository;
    @Mock
    private VetRepository vetRepository;
    @Mock
    private OwnerRepository ownerRepository;
    @Mock
    private VisitRepository visitRepository;
    @Mock
    private SpecialtyRepository specialtyRepository;
    @Mock
    private PetTypeRepository petTypeRepository;

    @InjectMocks
    private ClinicServiceImpl clinicService;

    private Owner owner;
    private Pet pet;
    private Vet vet;
    private Visit visit;
    private Specialty specialty;
    private PetType petType;

    @BeforeEach
    void setUp() {
        owner = new Owner();
        owner.setId(1);
        owner.setFirstName("George");
        owner.setLastName("Franklin");

        petType = new PetType();
        petType.setId(1);
        petType.setName("cat");

        pet = new Pet();
        pet.setId(1);
        pet.setName("Leo");
        pet.setType(petType);
        pet.setOwner(owner);

        vet = new Vet();
        vet.setId(1);
        vet.setFirstName("James");
        vet.setLastName("Carter");

        visit = new Visit();
        visit.setId(1);
        visit.setPet(pet);
        visit.setDescription("rabies shot");

        specialty = new Specialty();
        specialty.setId(1);
        specialty.setName("radiology");
    }

    //------------------------------ Pet Tests ------------------------------//

    @Test
    void shouldFindPetById() {
        when(petRepository.findById(1)).thenReturn(pet);
        Pet foundPet = clinicService.findPetById(1);
        assertNotNull(foundPet);
        assertEquals("Leo", foundPet.getName());
    }

    @Test
    void shouldNotFindPetById() {
        when(petRepository.findById(99)).thenReturn(null);
        Pet foundPet = clinicService.findPetById(99);
        assertNull(foundPet);
    }

    @Test
    void shouldFindAllPets() {
        when(petRepository.findAll()).thenReturn(Arrays.asList(pet, new Pet()));
        Collection<Pet> pets = clinicService.findAllPets();
        assertEquals(2, pets.size());
    }

    @Test
    void shouldSavePet() {
        when(petTypeRepository.findById(1)).thenReturn(petType);
        clinicService.savePet(pet);
        verify(petRepository).save(pet);
    }

    @Test
    void shouldDeletePet() {
        clinicService.deletePet(pet);
        verify(petRepository).delete(pet);
    }

    //------------------------------ Owner Tests ------------------------------//

    @Test
    void shouldFindOwnerById() {
        when(ownerRepository.findById(1)).thenReturn(owner);
        Owner foundOwner = clinicService.findOwnerById(1);
        assertNotNull(foundOwner);
        assertEquals("Franklin", foundOwner.getLastName());
    }

    @Test
    void shouldNotFindOwnerById() {
        when(ownerRepository.findById(99)).thenReturn(null);
        Owner foundOwner = clinicService.findOwnerById(99);
        assertNull(foundOwner);
    }

    @Test
    void shouldFindOwnerByLastName() {
        when(ownerRepository.findByLastName("Franklin")).thenReturn(Arrays.asList(owner));
        Collection<Owner> owners = clinicService.findOwnerByLastName("Franklin");
        assertEquals(1, owners.size());
        assertEquals("George", owners.iterator().next().getFirstName());
    }

    @Test
    void shouldFindAllOwners() {
        when(ownerRepository.findAll()).thenReturn(Arrays.asList(owner, new Owner()));
        Collection<Owner> owners = clinicService.findAllOwners();
        assertEquals(2, owners.size());
    }

    @Test
    void shouldSaveOwner() {
        clinicService.saveOwner(owner);
        verify(ownerRepository).save(owner);
    }

    @Test
    void shouldDeleteOwner() {
        clinicService.deleteOwner(owner);
        verify(ownerRepository).delete(owner);
    }

    //------------------------------ Vet Tests ------------------------------//

    @Test
    void shouldFindVetById() {
        when(vetRepository.findById(1)).thenReturn(vet);
        Vet foundVet = clinicService.findVetById(1);
        assertNotNull(foundVet);
        assertEquals("Carter", foundVet.getLastName());
    }

    @Test
    void shouldNotFindVetById() {
        when(vetRepository.findById(99)).thenReturn(null);
        Vet foundVet = clinicService.findVetById(99);
        assertNull(foundVet);
    }

    @Test
    void shouldFindAllVets() {
        when(vetRepository.findAll()).thenReturn(Arrays.asList(vet, new Vet()));
        Collection<Vet> vets = clinicService.findAllVets();
        assertEquals(2, vets.size());
    }

    @Test
    void shouldFindVets() {
        when(vetRepository.findAll()).thenReturn(Arrays.asList(vet));
        Collection<Vet> vets = clinicService.findVets();
        assertFalse(vets.isEmpty());
    }

    @Test
    void shouldSaveVet() {
        clinicService.saveVet(vet);
        verify(vetRepository).save(vet);
    }

    @Test
    void shouldDeleteVet() {
        clinicService.deleteVet(vet);
        verify(vetRepository).delete(vet);
    }

    //------------------------------ Visit Tests ------------------------------//

    @Test
    void shouldFindVisitById() {
        when(visitRepository.findById(1)).thenReturn(visit);
        Visit foundVisit = clinicService.findVisitById(1);
        assertNotNull(foundVisit);
        assertEquals("rabies shot", foundVisit.getDescription());
    }

    @Test
    void shouldNotFindVisitById() {
        when(visitRepository.findById(99)).thenReturn(null);
        Visit foundVisit = clinicService.findVisitById(99);
        assertNull(foundVisit);
    }

    @Test
    void shouldFindAllVisits() {
        when(visitRepository.findAll()).thenReturn(Arrays.asList(visit, new Visit()));
        Collection<Visit> visits = clinicService.findAllVisits();
        assertEquals(2, visits.size());
    }

    @Test
    void shouldFindVisitsByPetId() {
        when(visitRepository.findByPetId(1)).thenReturn(Arrays.asList(visit));
        Collection<Visit> visits = clinicService.findVisitsByPetId(1);
        assertEquals(1, visits.size());
    }

    @Test
    void shouldSaveVisit() {
        clinicService.saveVisit(visit);
        verify(visitRepository).save(visit);
    }

    @Test
    void shouldDeleteVisit() {
        clinicService.deleteVisit(visit);
        verify(visitRepository).delete(visit);
    }

    //------------------------------ PetType Tests ------------------------------//

    @Test
    void shouldFindPetTypeById() {
        when(petTypeRepository.findById(1)).thenReturn(petType);
        PetType foundPetType = clinicService.findPetTypeById(1);
        assertNotNull(foundPetType);
        assertEquals("cat", foundPetType.getName());
    }

    @Test
    void shouldNotFindPetTypeById() {
        when(petTypeRepository.findById(99)).thenReturn(null);
        PetType foundPetType = clinicService.findPetTypeById(99);
        assertNull(foundPetType);
    }

    @Test
    void shouldFindAllPetTypes() {
        when(petTypeRepository.findAll()).thenReturn(Arrays.asList(petType, new PetType()));
        Collection<PetType> petTypes = clinicService.findAllPetTypes();
        assertEquals(2, petTypes.size());
    }

    @Test
    void shouldFindPetTypes() {
        when(petRepository.findPetTypes()).thenReturn(Arrays.asList(petType));
        Collection<PetType> petTypes = clinicService.findPetTypes();
        assertFalse(petTypes.isEmpty());
    }

    @Test
    void shouldSavePetType() {
        clinicService.savePetType(petType);
        verify(petTypeRepository).save(petType);
    }

    @Test
    void shouldDeletePetType() {
        clinicService.deletePetType(petType);
        verify(petTypeRepository).delete(petType);
    }

    //------------------------------ Specialty Tests ------------------------------//

    @Test
    void shouldFindSpecialtyById() {
        when(specialtyRepository.findById(1)).thenReturn(specialty);
        Specialty foundSpecialty = clinicService.findSpecialtyById(1);
        assertNotNull(foundSpecialty);
        assertEquals("radiology", foundSpecialty.getName());
    }

    @Test
    void shouldNotFindSpecialtyById() {
        when(specialtyRepository.findById(99)).thenReturn(null);
        Specialty foundSpecialty = clinicService.findSpecialtyById(99);
        assertNull(foundSpecialty);
    }

    @Test
    void shouldFindAllSpecialties() {
        when(specialtyRepository.findAll()).thenReturn(Arrays.asList(specialty, new Specialty()));
        Collection<Specialty> specialties = clinicService.findAllSpecialties();
        assertEquals(2, specialties.size());
    }

    @Test
    void shouldFindSpecialtiesByNameIn() {
        Set<String> names = new HashSet<>(Arrays.asList("radiology", "surgery"));
        when(specialtyRepository.findSpecialtiesByNameIn(names)).thenReturn(Arrays.asList(specialty));
        List<Specialty> foundSpecialties = clinicService.findSpecialtiesByNameIn(names);
        assertEquals(1, foundSpecialties.size());
    }

    @Test
    void shouldSaveSpecialty() {
        clinicService.saveSpecialty(specialty);
        verify(specialtyRepository).save(specialty);
    }

    @Test
    void shouldDeleteSpecialty() {
        clinicService.deleteSpecialty(specialty);
        verify(specialtyRepository).delete(specialty);
    }
}
