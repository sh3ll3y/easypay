document.addEventListener('turbolinks:load', () => {
  const modal = document.getElementById('transaction-form-modal');
  if (modal) {
    document.querySelectorAll('.recharge-link').forEach(link => {
      link.addEventListener('click', (event) => {
        event.preventDefault();
        fetch(link.href, {
          headers: {
            'Accept': 'text/javascript'
          }
        })
        .then(response => response.text())
        .then(html => {
          modal.querySelector('.modal-content').innerHTML = html;
          new bootstrap.Modal(modal).show();
        });
      });
    });

    modal.addEventListener('submit', (event) => {
      event.preventDefault();
      const form = event.target;
      fetch(form.action, {
        method: form.method,
        body: new FormData(form),
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.status === 'success') {
          alert(data.message);
          window.location.href = data.redirect_to;
        } else {
          alert(data.message || data.errors.join(', '));
        }
        bootstrap.Modal.getInstance(modal).hide();
      });
    });
  }

  const searchForm = document.getElementById("search-form");
  const searchInput = document.getElementById("search-query");

  if (searchInput) {
    searchInput.addEventListener("input", function() {
      clearTimeout(window.searchTimeout);

      window.searchTimeout = setTimeout(function() {
        searchForm.requestSubmit(); // Submit the form using AJAX
      }, 300); 
    });
  }

});
