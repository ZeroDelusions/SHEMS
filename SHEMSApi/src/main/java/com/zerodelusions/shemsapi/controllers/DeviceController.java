package com.zerodelusions.shemsapi.controllers;

import com.zerodelusions.shemsapi.models.Device;
import com.zerodelusions.shemsapi.services.DeviceService;
import com.zerodelusions.shemsapi.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/device")
@RequiredArgsConstructor(onConstructor = @__(@Autowired))
public class DeviceController {

    private final DeviceService deviceService;

    @GetMapping
    public List<Device> findAllDevices(@AuthenticationPrincipal Jwt jwt) {
        String googleId = jwt.getSubject();
        return deviceService.findAllDevicesByGoogleId(googleId);
    }

    @PostMapping
    public ResponseEntity<Device> addDevice(@AuthenticationPrincipal Jwt jwt, @RequestBody Device device) {
        String googleId = jwt.getSubject();
        Device newDevice = deviceService.addDevice(googleId, device);
        return ResponseEntity.status(HttpStatus.CREATED).body(newDevice);
    }

    @PutMapping("/{deviceId}")
    public ResponseEntity<Device> updateDevice(@AuthenticationPrincipal Jwt jwt, @PathVariable Long deviceId, @RequestBody Device device) {
        String googleId = jwt.getSubject();
        Device updatedDevice = deviceService.updateDevice(googleId, deviceId, device);
        return ResponseEntity.ok(updatedDevice);
    }

    @DeleteMapping("/{deviceId}")
    public ResponseEntity<Device> deleteDevice(@AuthenticationPrincipal Jwt jwt, @PathVariable Long deviceId) {
        String googleId = jwt.getSubject();
        Device deletedDevice = deviceService.deleteDevice(googleId, deviceId);
        return ResponseEntity.ok(deletedDevice); // Return the deleted device
    }

}
