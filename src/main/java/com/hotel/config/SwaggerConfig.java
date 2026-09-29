package com.hotel.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        final String securitySchemeName = "bearerAuth";

        return new OpenAPI()
                .info(new Info()
                        .title("Hotel Management System API")
                        .description("ប្រព័ន្ធគ្រប់គ្រង និង REST APIs សម្រាប់កម្មវិធីសណ្ឋាគារ (Frontend Integration)")
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("Hotel Development Team")
                                .email("support@hoteldomain.com"))
                        .license(new License().name("Apache 2.0").url("http://springdoc.org")))
                // បន្ថែម Authorization Header សម្រាប់ JWT Authentication ក្នុង Swagger UI
                .addSecurityItem(new SecurityRequirement().addList(securitySchemeName))
                .components(new Components()
                        .addSecuritySchemes(securitySchemeName,
                                new SecurityScheme()
                                        .name(securitySchemeName)
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")));
    }
}