package com.zerodelusions.shemsapi.services;

import com.zerodelusions.shemsapi.enums.AggregationLevel;
import com.zerodelusions.shemsapi.exceptions.GlobalExceptionHandler;
import com.zerodelusions.shemsapi.models.Device;
import com.zerodelusions.shemsapi.models.EnergyConsumption;
import com.zerodelusions.shemsapi.models.User;
import com.zerodelusions.shemsapi.repositories.DeviceRepository;
import com.zerodelusions.shemsapi.repositories.EnergyConsumptionRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.OffsetDateTime;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor(onConstructor = @__(@Autowired))
public class EnergyConsumptionService {

    private final EnergyConsumptionRepository energyConsumptionRepository;
    private final DeviceRepository deviceRepository;
    private final UserService userService;

    public List<EnergyConsumption> getDeviceEnergyConsumption(String googleId, Long deviceId, OffsetDateTime start, OffsetDateTime end) {
        User user = userService.getUserByGoogleId(googleId);
        Device device = deviceRepository.findByIdAndUser(deviceId, user)
                .orElseThrow(() -> new GlobalExceptionHandler.ResourceNotFoundException("Device not found or you don't have permission to access it"));
        return energyConsumptionRepository.findByDeviceAndTimestampBetween(device, start, end);
    }

    public List<EnergyConsumption> getDevicesEnergyConsumption(String googleId, List<Long> deviceIds, OffsetDateTime start, OffsetDateTime end) {
        User user = userService.getUserByGoogleId(googleId);
        List<Device> devices = deviceRepository.findByIdInAndUser(deviceIds, user)
                .orElseThrow(() -> new GlobalExceptionHandler.ResourceNotFoundException("One or more devices not found or you don't have permission to access them"));
        return energyConsumptionRepository.findByDeviceInAndTimestampBetween(devices, start, end);
    }

    public List<EnergyConsumption> getAllDevicesEnergyConsumption(String googleId, OffsetDateTime start, OffsetDateTime end) {
        User user = userService.getUserByGoogleId(googleId);
        List<Device> devices = deviceRepository.findByUser(user);
        return energyConsumptionRepository.findByDeviceInAndTimestampBetween(devices, start, end);
    }

    public EnergyConsumption addEnergyConsumption(String googleId, Long deviceId, EnergyConsumption energyConsumption) {
        User user = userService.getUserByGoogleId(googleId);
        Device device = deviceRepository.findByIdAndUser(deviceId, user)
                .orElseThrow(() -> new GlobalExceptionHandler.ResourceNotFoundException("Device not found or you don't have permission to add energy consumption"));

        energyConsumption.setDevice(device);
        return energyConsumptionRepository.save(energyConsumption);
    }

    public EnergyConsumption getLatestEnergyConsumption(String googleId, Long deviceId) {
        User user = userService.getUserByGoogleId(googleId);
        Device device = deviceRepository.findByIdAndUser(deviceId, user)
                .orElseThrow(() -> new GlobalExceptionHandler.ResourceNotFoundException("Device not found or you don't have permission to access it"));
        return energyConsumptionRepository.findTopByDeviceOrderByTimestampDesc(device);
    }

    // Aggregation

    public List<EnergyConsumption> getAggregatedAllDevicesEnergyConsumption(String googleId, OffsetDateTime start, OffsetDateTime end, AggregationLevel aggregationLevel) {
        User user = userService.getUserByGoogleId(googleId);
        List<Device> devices = deviceRepository.findByUser(user);

        List<EnergyConsumption> rawData = energyConsumptionRepository.findByDeviceInAndTimestampBetween(devices, start, end);

        return aggregateDataForAllDevices(rawData, aggregationLevel);
    }

    private List<EnergyConsumption> aggregateDataForAllDevices(List<EnergyConsumption> rawData, AggregationLevel aggregationLevel) {
        Map<OffsetDateTime, Double> aggregatedMap = new TreeMap<>();

        for (EnergyConsumption consumption : rawData) {
            OffsetDateTime roundedTimestamp = roundTimestamp(consumption.getTimestamp(), aggregationLevel);
            aggregatedMap.merge(roundedTimestamp, consumption.getPowerUsage(), Double::sum);
        }

        AtomicLong index = new AtomicLong(0);
        return aggregatedMap.entrySet().stream()
                .map(entry -> new EnergyConsumption(index.getAndIncrement(), null, entry.getKey(), entry.getValue()))
                .collect(Collectors.toList());
    }

    public List<EnergyConsumption> getAggregatedDeviceEnergyConsumption(String googleId, Long deviceId, OffsetDateTime start, OffsetDateTime end, AggregationLevel aggregationLevel) {
        User user = userService.getUserByGoogleId(googleId);
        Device device = deviceRepository.findByIdAndUser(deviceId, user)
                .orElseThrow(() -> new GlobalExceptionHandler.ResourceNotFoundException("Device not found or you don't have permission to access it"));

        List<EnergyConsumption> rawData = energyConsumptionRepository.findByDeviceAndTimestampBetween(device, start, end);

        return aggregateData(rawData, aggregationLevel, device);
    }

    private List<EnergyConsumption> aggregateData(List<EnergyConsumption> rawData, AggregationLevel aggregationLevel, Device device) {
        Map<OffsetDateTime, Double> aggregatedMap = new TreeMap<>();

        for (EnergyConsumption consumption : rawData) {
            OffsetDateTime roundedTimestamp = roundTimestamp(consumption.getTimestamp(), aggregationLevel);
            aggregatedMap.merge(roundedTimestamp, consumption.getPowerUsage(), Double::sum);
        }

        AtomicLong index = new AtomicLong(0);
        return aggregatedMap.entrySet().stream()
                .map(entry -> new EnergyConsumption(index.getAndIncrement(), device, entry.getKey(), entry.getValue()))
                .collect(Collectors.toList());

    }

    private OffsetDateTime roundTimestamp(OffsetDateTime timestamp, AggregationLevel aggregationLevel) {
        return switch (aggregationLevel) {
            case MINUTELY -> timestamp.truncatedTo(ChronoUnit.MINUTES);
            case HOURLY -> timestamp.truncatedTo(ChronoUnit.HOURS);
            case DAILY -> timestamp.truncatedTo(ChronoUnit.DAYS);
            case WEEKLY ->
                    timestamp.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY)).truncatedTo(ChronoUnit.DAYS);
            case MONTHLY -> timestamp.withDayOfMonth(1).truncatedTo(ChronoUnit.DAYS);
            default -> throw new IllegalArgumentException("Unsupported aggregation level");
        };
    }
}