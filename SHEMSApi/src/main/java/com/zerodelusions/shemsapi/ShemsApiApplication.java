package com.zerodelusions.shemsapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class ShemsApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(ShemsApiApplication.class, args);
	}

}
