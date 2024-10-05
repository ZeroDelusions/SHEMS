package com.zerodelusions.shemsapi.controllers;

import com.zerodelusions.shemsapi.models.User;
import com.zerodelusions.shemsapi.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor(onConstructor = @__(@Autowired))
public class AuthController {

    private final UserService userService;

    @GetMapping("/success")
    public ResponseEntity<User> handleAuthSuccess(@AuthenticationPrincipal Jwt jwt) {
        String email = jwt.getClaim("email");
        String name = jwt.getClaim("name");
        String googleId = jwt.getSubject();

        User user = userService.findOrCreateUser(googleId, email, name);
        return ResponseEntity.ok(user);
    }
}
