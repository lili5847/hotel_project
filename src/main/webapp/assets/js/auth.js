(function () {
    // Show / hide password buttons
    document.querySelectorAll('[data-toggle-password]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var input = document.querySelector(btn.getAttribute('data-toggle-password'));
            var show = input.type === 'password';
            input.type = show ? 'text' : 'password';
            btn.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
            btn.querySelector('i').className = show ? 'bi bi-eye-slash' : 'bi bi-eye';
        });
    });

    // Browser-side validation (the server must still validate everything)
    document.querySelectorAll('form.needs-validation').forEach(function (form) {
        var pw = form.querySelector('#password');
        var confirm = form.querySelector('#confirmPassword');

        function checkMatch() {
            if (!confirm) return;
            confirm.setCustomValidity(confirm.value !== pw.value ? 'Passwords do not match' : '');
        }

        if (confirm) {
            pw.addEventListener('input', checkMatch);
            confirm.addEventListener('input', checkMatch);
        }

        // Clear server-side error styling once the user edits the field
        form.querySelectorAll('.is-invalid').forEach(function (el) {
            el.addEventListener('input', function () {
                el.classList.remove('is-invalid');
            });
        });

        form.addEventListener('submit', function (e) {
            checkMatch();
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });
})();