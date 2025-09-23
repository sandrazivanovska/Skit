package org.springframework.samples.petclinic.junit.user_service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.samples.petclinic.model.Role;
import org.springframework.samples.petclinic.model.User;
import org.springframework.samples.petclinic.repository.UserRepository;
import org.springframework.samples.petclinic.service.UserServiceImpl;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceImplTests {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserServiceImpl userService;

    @Test
    void shouldSaveUserWithValidRole() {
        User user = new User();
        user.setUsername("testuser");
        user.setPassword("password");

        Role role = new Role();
        role.setName("OWNER");
        Set<Role> roles = new HashSet<>(Collections.singletonList(role));
        user.setRoles(roles);

        userService.saveUser(user);

        verify(userRepository).save(user);
        assertEquals("ROLE_OWNER", role.getName());
        assertEquals(user, role.getUser());
    }

    @Test
    void shouldSaveUserWithPredefinedRole() {
        User user = new User();
        user.setUsername("testuser2");
        user.setPassword("password2");

        Role role = new Role();
        role.setName("ROLE_VET");
        Set<Role> roles = new HashSet<>(Collections.singletonList(role));
        user.setRoles(roles);

        userService.saveUser(user);

        // Then
        verify(userRepository).save(user);
        assertEquals("ROLE_VET", role.getName());
        assertEquals(user, role.getUser());
    }

    @Test
    void shouldThrowExceptionWhenUserHasNoRoles() {
        User user = new User();
        user.setUsername("nouserole");
        user.setPassword("password");
        user.setRoles(new HashSet<>()); // Empty role set

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> {
            userService.saveUser(user);
        });

        assertEquals("User must have at least a role set!", exception.getMessage());
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void shouldSetUserOnRoleIfItIsNull() {
        User user = new User();
        user.setUsername("roleless");
        user.setPassword("password");

        Role role = new Role();
        role.setName("ADMIN");
        role.setUser(null); // Role has no user set initially
        user.setRoles(new HashSet<>(Collections.singletonList(role)));

        userService.saveUser(user);

        verify(userRepository).save(user);
        assertEquals(user, role.getUser());
    }
}
