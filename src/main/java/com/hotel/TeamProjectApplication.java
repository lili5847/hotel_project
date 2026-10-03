package com.hotel;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class TeamProjectApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(TeamProjectApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(
            SpringApplicationBuilder application) {
        return application.sources(TeamProjectApplication.class);
    }
}