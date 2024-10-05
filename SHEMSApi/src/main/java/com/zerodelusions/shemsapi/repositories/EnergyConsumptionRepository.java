package com.zerodelusions.shemsapi.repositories;

import com.zerodelusions.shemsapi.models.Device;
import com.zerodelusions.shemsapi.models.EnergyConsumption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.OffsetDateTime;
import java.util.List;

@Repository
public interface EnergyConsumptionRepository extends JpaRepository<EnergyConsumption, Long> {
    List<EnergyConsumption> findByDeviceAndTimestampBetween(Device device, OffsetDateTime start, OffsetDateTime end);
    List<EnergyConsumption> findByDeviceInAndTimestampBetween(List<Device> devices, OffsetDateTime start, OffsetDateTime end);
    EnergyConsumption findTopByDeviceOrderByTimestampDesc(Device device);
}

