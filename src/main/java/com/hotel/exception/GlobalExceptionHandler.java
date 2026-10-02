package com.hotel.exception;

import com.hotel.dto.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // 1. គ្រប់គ្រង Bad Credentials Exception (401 Unauthorized - ពេលបញ្ចូល Username/Email ឬ Password ខុស)
    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ApiResponse<Void>> handleBadCredentialsException(BadCredentialsException ex) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ApiResponse.error(401, "Username/Email ឬ Password មិនត្រឹមត្រូវឡើយ!"));
    }

    // 2. គ្រប់គ្រង AccessDeniedException (403 Forbidden - ពេលគ្មានសិទ្ធិ ឬដើរមិនឆ្លង @PreAuthorize)
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiResponse<Void>> handleAccessDeniedException(AccessDeniedException ex) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(ApiResponse.error(403, "អ្នកគ្មានសិទ្ធិគ្រប់គ្រាន់ក្នុងការអនុវត្តសកម្មភាពនេះឡើយ!"));
    }

    // 3. គ្រប់គ្រង Form Validation Exceptions (@Valid Input Error - 400 Bad Request)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Map<String, String>>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(400, "ការបញ្ចូលទិន្នន័យមិនត្រឹមត្រូវឡើយ", errors));
    }

    // 4. គ្រប់គ្រង Business/Runtime Exceptions (400 Bad Request)
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ApiResponse<Void>> handleRuntimeException(RuntimeException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(400, ex.getMessage()));
    }

    // 5. គ្រប់គ្រង General Exception (500 Internal Server Error)
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGlobalException(Exception ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error(500, "មានបញ្ហាបច្ចេកទេសក្នុងប្រព័ន្ធ៖ " + ex.getMessage()));
    }
}