package com.zerodelusions.shemsapi.services;

import com.zerodelusions.shemsapi.exceptions.GlobalExceptionHandler;
import com.zerodelusions.shemsapi.models.Device;
import com.zerodelusions.shemsapi.models.User;
import com.zerodelusions.shemsapi.repositories.DeviceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor(onConstructor = @__(@Autowired))
public class DeviceService {

    private final DeviceRepository deviceRepository;
    private final UserService userService;

    public List<Device> findAllDevicesByGoogleId(String googleId) {
        User user = userService.getUserByGoogleId(googleId);
        return deviceRepository.findByUser(user);
    }

    public Device addDevice(String googleId, Device device) {
        User user = userService.getUserByGoogleId(googleId);
        device.setUser(user);
        return deviceRepository.save(device);
    }

    public Device updateDevice(String googleId, Long deviceId, Device updatedDevice) {
        User user = userService.getUserByGoogleId(googleId);
        Device existingDevice = deviceRepository.findByIdAndUser(deviceId, user)
                .orElseThrow(() -> new GlobalExceptionHandler.ResourceNotFoundException("Device not found or you don't have permission to update it"));

        existingDevice.setName(updatedDevice.getName());
        existingDevice.setType(updatedDevice.getType());
        existingDevice.setManufacturer(updatedDevice.getManufacturer());
        existingDevice.setModel(updatedDevice.getModel());
        existingDevice.setPowerRating(updatedDevice.getPowerRating());
        existingDevice.setStatus(updatedDevice.getStatus());
        existingDevice.setLocation(updatedDevice.getLocation());

        return deviceRepository.save(existingDevice);
    }

    public Device deleteDevice(String googleId, Long deviceId) {
        User user = userService.getUserByGoogleId(googleId);
        Device device = deviceRepository.findByIdAndUser(deviceId, user)
                .orElseThrow(() -> new GlobalExceptionHandler.ResourceNotFoundException("Device not found or you don't have permission to delete it"));

        deviceRepository.delete(device);
        return device; // Return the deleted device
    }

}
