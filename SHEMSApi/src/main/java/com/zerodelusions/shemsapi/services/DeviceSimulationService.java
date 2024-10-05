package com.zerodelusions.shemsapi.services;

import com.zerodelusions.shemsapi.enums.DeviceType;
import com.zerodelusions.shemsapi.models.Device;
import com.zerodelusions.shemsapi.models.EnergyConsumption;
import com.zerodelusions.shemsapi.repositories.DeviceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

@Service
@RequiredArgsConstructor(onConstructor = @__(@Autowired))
public class DeviceSimulationService {

    private final DeviceRepository deviceRepository;
    private final EnergyConsumptionService energyConsumptionService;

    private final Random random = new Random();

    // Map to store average consumption and variability based on device type
    private static final HashMap<DeviceType, Double[]> DEVICE_CONSUMPTION_MAP = new HashMap<>();

    static {
        DEVICE_CONSUMPTION_MAP.put(DeviceType.THERMOSTAT, new Double[]{50.0, 0.1}); // Avg 50W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.LIGHT_BULB, new Double[]{10.0, 0.2}); // Avg 10W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.SMART_PLUG, new Double[]{15.0, 0.1}); // Avg 15W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.SECURITY_CAMERA, new Double[]{30.0, 0.1}); // Avg 30W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.SMART_DOOR_LOCK, new Double[]{5.0, 0.2}); // Avg 5W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.REFRIGERATOR, new Double[]{150.0, 0.1}); // Avg 150W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.WASHING_MACHINE, new Double[]{500.0, 0.2}); // Avg 500W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.DRYER, new Double[]{3000.0, 0.1}); // Avg 3000W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.DISHWASHER, new Double[]{1500.0, 0.2}); // Avg 1500W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.AIR_CONDITIONER, new Double[]{2000.0, 0.1}); // Avg 2000W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.WATER_HEATER, new Double[]{4500.0, 0.2}); // Avg 4500W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.OVEN, new Double[]{3000.0, 0.1}); // Avg 3000W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.MICROWAVE, new Double[]{1000.0, 0.2}); // Avg 1000W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.VACUUM_CLEANER, new Double[]{1500.0, 0.2}); // Avg 1500W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.SMART_TV, new Double[]{100.0, 0.2}); // Avg 100W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.FAN, new Double[]{75.0, 0.1}); // Avg 75W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.SMART_SPEAKER, new Double[]{10.0, 0.2}); // Avg 10W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.GARAGE_DOOR_OPENER, new Double[]{100.0, 0.1}); // Avg 100W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.SMOKE_DETECTOR, new Double[]{5.0, 0.1}); // Avg 5W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.SMART_SPRINKLER, new Double[]{50.0, 0.2}); // Avg 50W, 20% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.ELECTRIC_CAR_CHARGER, new Double[]{3000.0, 0.1}); // Avg 3000W, 10% variability
        DEVICE_CONSUMPTION_MAP.put(DeviceType.HOME_BATTERY, new Double[]{1000.0, 0.1}); // Avg 1000W, 10% variability
    }

    @Scheduled(fixedRate = 1000)
    public void simulateDeviceConsumption() {
        List<Device> devices = deviceRepository.findAll();

        for (Device device : devices) {
            double consumption;
            if (Boolean.TRUE.equals(device.getStatus())) { // Only simulate for active devices
                consumption = calculateEnergyConsumption(device);
            } else {
                consumption = 0; // Set consumption to 0 for inactive devices
            }

            // Create energy consumption entry
            EnergyConsumption energyConsumption = new EnergyConsumption();
            energyConsumption.setDevice(device);
            energyConsumption.setTimestamp(OffsetDateTime.now());
            energyConsumption.setPowerUsage(consumption);

            // Save the energy consumption entry
            energyConsumptionService.addEnergyConsumption(device.getUser().getGoogleId(), device.getId(), energyConsumption);
        }
    }

    private double calculateEnergyConsumption(Device device) {
        DeviceType deviceType = device.getType();
        Double[] consumptionData = DEVICE_CONSUMPTION_MAP.get(deviceType);

        if (consumptionData == null) {
            // Fallback to base consumption if device type is unknown
            return device.getPowerRating();
        }

        double averageConsumption = consumptionData[0];
        double variabilityPercentage = consumptionData[1];

        // Simulate variability
        double variability = averageConsumption * (random.nextDouble() * variabilityPercentage * 2 - variabilityPercentage);
        return averageConsumption + variability;
    }
}