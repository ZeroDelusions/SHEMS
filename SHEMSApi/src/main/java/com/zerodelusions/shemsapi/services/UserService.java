package com.zerodelusions.shemsapi.services;

import com.zerodelusions.shemsapi.exceptions.GlobalExceptionHandler;
import com.zerodelusions.shemsapi.models.User;
import com.zerodelusions.shemsapi.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor(onConstructor = @__(@Autowired))
public class UserService {

    private final UserRepository userRepository;

    public User getUserById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new GlobalExceptionHandler.ResourceNotFoundException("User not found"));
    }

    public User addUser(User user) {
        return userRepository.save(user);
    }

    public User findOrCreateUser(String googleId, String email, String name) {
        return userRepository.findByGoogleId(googleId)
                .orElseGet(() -> {
                    User newUser = new User(googleId, email, name);
                    return userRepository.save(newUser);
                });
    }

    public User getUserByGoogleId(String googleId) {
        return userRepository.findByGoogleId(googleId)
                .orElseThrow(() -> new GlobalExceptionHandler.ResourceNotFoundException("User not found"));
    }
}

