package com.zerodelusions.shemsapi.controllers;

import com.zerodelusions.shemsapi.DTO.EnergyConsumptionDTO;
import com.zerodelusions.shemsapi.enums.AggregationLevel;
import com.zerodelusions.shemsapi.models.EnergyConsumption;
import com.zerodelusions.shemsapi.services.EnergyConsumptionService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.time.OffsetDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/v1/energy-consumption")
@RequiredArgsConstructor
public class EnergyConsumptionController {

    private final EnergyConsumptionService energyConsumptionService;

    @GetMapping("/device/{deviceId}")
    public ResponseEntity<List<EnergyConsumption>> getDeviceEnergyConsumption(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable Long deviceId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime end
    ) {
        String googleId = jwt.getSubject();
        List<EnergyConsumption> consumptions = energyConsumptionService.getDeviceEnergyConsumption(googleId, deviceId, start, end);
        return ResponseEntity.ok(consumptions);
    }

    @GetMapping("/devices")
    public ResponseEntity<List<EnergyConsumption>> getDevicesEnergyConsumption(
            @AuthenticationPrincipal Jwt jwt,
            @RequestParam List<Long> deviceIds,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime end
    ) {
        String googleId = jwt.getSubject();
        List<EnergyConsumption> consumptions = energyConsumptionService.getDevicesEnergyConsumption(googleId, deviceIds, start, end);
        return ResponseEntity.ok(consumptions);
    }

    @GetMapping("/all-devices/aggregated")
    public ResponseEntity<List<EnergyConsumption>> getAggregatedAllDevicesEnergyConsumption(
            @AuthenticationPrincipal Jwt jwt,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime end,
            @RequestParam AggregationLevel aggregationLevel
    ) {
        String googleId = jwt.getSubject();
        List<EnergyConsumption> aggregatedConsumptions = energyConsumptionService.getAggregatedAllDevicesEnergyConsumption(googleId, start, end, aggregationLevel);
        return ResponseEntity.ok(aggregatedConsumptions);
    }

    @GetMapping("/all-devices")
    public ResponseEntity<List<EnergyConsumption>> getAllDevicesEnergyConsumption(
            @AuthenticationPrincipal Jwt jwt,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime end
    ) {
        String googleId = jwt.getSubject();
        List<EnergyConsumption> consumptions = energyConsumptionService.getAllDevicesEnergyConsumption(googleId, start, end);
        return ResponseEntity.ok(consumptions);
    }

    @PostMapping("/device/{deviceId}")
    public ResponseEntity<EnergyConsumption> addEnergyConsumption(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable Long deviceId,
            @RequestBody EnergyConsumption energyConsumption) {
        String googleId = jwt.getSubject();
        EnergyConsumption newConsumption = energyConsumptionService.addEnergyConsumption(googleId, deviceId, energyConsumption);
        return ResponseEntity.ok(newConsumption);
    }

    @GetMapping("/device/{deviceId}/aggregated")
    public ResponseEntity<List<EnergyConsumption>> getAggregatedDeviceEnergyConsumption(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable Long deviceId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime end,
            @RequestParam AggregationLevel aggregationLevel
    ) {
        String googleId = jwt.getSubject();
        List<EnergyConsumption> aggregatedConsumptions = energyConsumptionService.getAggregatedDeviceEnergyConsumption(googleId, deviceId, start, end, aggregationLevel);
        return ResponseEntity.ok(aggregatedConsumptions);
    }

    @GetMapping("/device/{deviceId}/latest")
    public ResponseEntity<EnergyConsumption> getLatestEnergyConsumption(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable Long deviceId) {
        String googleId = jwt.getSubject();
        EnergyConsumption latestConsumption = energyConsumptionService.getLatestEnergyConsumption(googleId, deviceId);
        return ResponseEntity.ok(latestConsumption);
    }
}