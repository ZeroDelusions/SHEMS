package com.zerodelusions.shemsapi.repositories;

import com.zerodelusions.shemsapi.models.Device;
import com.zerodelusions.shemsapi.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DeviceRepository extends JpaRepository<Device, Long> {
    List<Device> findByUser(User user);
    Optional<Device> findByIdAndUser(Long id, User user);
    Optional<List<Device>> findByIdInAndUser(List<Long> deviceIds, User user);
}

