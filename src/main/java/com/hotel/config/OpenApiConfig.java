package com.hotel.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
        info = @Info(
                title = "Hotel Management System API",
                version = "v1.0",
                description = "RESTful APIs សម្រាប់ការគ្រប់គ្រងសណ្ឋាគារ ភ្ជាប់ជាមួយ JWT Authentication",
                contact = @Contact(
                        name = "Romas Saroeurng",
                        email = "romas@example.com"
                )
        ),
        security = {
                @SecurityRequirement(name = "bearerAuth") // អនុវត្ត JWT Security លើគ្រប់ API Endpoints ទាំងអស់ក្នុង Swagger
        }
)
@SecurityScheme(
        name = "bearerAuth",
        type = SecuritySchemeType.HTTP,
        scheme = "bearer",
        bearerFormat = "JWT",
        description = "សូមបញ្ចូល JWT Token ដែលទទួលបានពី Login API (ឧទាហរណ៍៖ `eyJhbGciOi...` ដោយមិនបាច់ថែមពាក្យ Bearer ឡើយ)"
)
public class OpenApiConfig {
}